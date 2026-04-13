param(
    [Parameter(Mandatory=$true)]
    [string]$file
)

# Validate file
if (-not (Test-Path $file)) {
    Write-Host "File not found: $file"
    exit 1
}

try {
    $lyrics = ffprobe -v error `
        -show_entries format_tags=lyrics `
        -of default=nw=1:nk=1 `
        "$file"
} catch {
    Write-Host "Error reading file with ffprobe."
    exit 1
}

if ($lyrics -and $lyrics.Trim()) {
    Write-Host "Lyrics:"
    $lyrics.Trim()
} else {
    Write-Host "No embedded lyrics found."
}