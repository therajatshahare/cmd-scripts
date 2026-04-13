param(
    [Parameter(Mandatory=$true)]
    [string]$file
)

# -------------------------------
# Validate file
# -------------------------------
if (-not (Test-Path $file)) {
    Write-Host "File not found: $file"
    exit 1
}

Write-Host "Metadata for: $file"
Write-Host "--------------------------"

# -------------------------------
# Get metadata using ffmpeg
# -------------------------------
try {
    $output = ffmpeg -hide_banner -i "$file" 2>&1
} catch {
    Write-Host "Error reading metadata."
    exit 1
}

# -------------------------------
# Filter metadata lines
# -------------------------------
$meta = $output | Where-Object {
    $_ -match '^\s+[a-zA-Z0-9_]+\s*:' -and $_ -notmatch 'Stream'
}

if ($meta) {
    $meta
} else {
    Write-Host "No metadata found."
}