param(
    [string]$res,
    [string]$filename,
    [string]$url
)

# -------------------------------
# Validate yt-dlp
# -------------------------------
if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
    Write-Host "yt-dlp not found. Please install and add to PATH."
    exit 1
}

# -------------------------------
# Argument handling
# -------------------------------
if (-not $url) {
    $url = $filename
    $filename = $res
    $res = ""
}

if (-not $filename -or -not $url) {
    Write-Host 'Usage: ytvideo [resolution] "filename" "URL"'
    exit 1
}

# -------------------------------
# Sanitize filename
# -------------------------------
$filename = $filename -replace '[\\/:*?"<>|]', '_'

# -------------------------------
# Output directory
# -------------------------------
$outputDir = "YT-DLP"
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# -------------------------------
# Format selection
# -------------------------------
$format = "bestvideo+bestaudio/best"

switch ($res.ToLower()) {
    "4k"     { $format = "bestvideo[height<=2160][height>=1440]+bestaudio/best" }
    "2k"     { $format = "bestvideo[height<=1440][height>=1080]+bestaudio/best" }
    "1080p"  { $format = "bestvideo[height<=1080][height>=720]+bestaudio/best" }
    "720p"   { $format = "bestvideo[height<=720][height>=480]+bestaudio/best" }
    "480p"   { $format = "bestvideo[height<=480][height>=360]+bestaudio/best" }
    "360p"   { $format = "bestvideo[height<=360][height>=240]+bestaudio/best" }
    "240p"   { $format = "bestvideo[height<=240]+bestaudio/best" }
}

# -------------------------------
# Subtitle detection
# -------------------------------
$subs = yt-dlp --list-subs "$url" 2>$null
$hasRealSub = $subs -match '^en ' -and $subs -notmatch 'auto-generated'

# -------------------------------
# Download
# -------------------------------
if ($hasRealSub) {
    Write-Host "Real English subtitles found. Downloading with subtitles..."
    yt-dlp -f $format --merge-output-format mkv --sub-lang en --write-subs --embed-subs `
        -o "$outputDir\$filename.mkv" "$url"
} else {
    Write-Host "No real English subtitles found. Downloading without subtitles..."
    yt-dlp -f $format --merge-output-format mkv `
        -o "$outputDir\$filename.mkv" "$url"
}

# -------------------------------
# Log
# -------------------------------
Add-Content "yt-dlp-log.txt" "[$(Get-Date)] Downloading $url as $filename.mkv"