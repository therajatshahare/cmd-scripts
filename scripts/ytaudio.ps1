param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$args
)

# -------------------------------
# Check tools
# -------------------------------
if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
    Write-Host "yt-dlp not found."
    exit 1
}

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Host "ffmpeg not found."
    exit 1
}

# -------------------------------
# Download and extract audio
# -------------------------------
yt-dlp `
    --extract-audio `
    --audio-format flac `
    --audio-quality 0 `
    -f bestaudio `
    --add-metadata `
    --embed-thumbnail `
    --postprocessor-args "ffmpeg:-compression_level 12" `
    -o "%(title)s.%(ext)s" `
    @args

# -------------------------------
# Fallback: convert leftover webm
# -------------------------------
Get-ChildItem *.webm -ErrorAction SilentlyContinue | ForEach-Object {
    $input = $_.FullName
    $output = [System.IO.Path]::ChangeExtension($input, ".flac")

    ffmpeg -i "$input" -compression_level 12 -y "$output"
    Remove-Item "$input"
}

# -------------------------------
# Detect newest FLAC file
# -------------------------------
$latest = Get-ChildItem *.flac |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $latest) {
    Write-Host "No FLAC file found."
    exit
}

$title = [System.IO.Path]::GetFileNameWithoutExtension($latest.Name)

# -------------------------------
# Ask for lyrics
# -------------------------------
$answer = Read-Host "Do you want to add lyrics from Genius? (y/n)"

if ($answer -ne "y") {
    return
}

Write-Host "Fetching lyrics for: $title"

# Run your Python script
$scriptPath = "$PSScriptRoot\lyrics.py"
python "$scriptPath" "$title" "$($latest.FullName)"

Write-Host "Lyrics embedded into $($latest.Name)"
