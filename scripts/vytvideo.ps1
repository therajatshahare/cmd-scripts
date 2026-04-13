param(
    [string]$res,
    [string]$filename,
    [string]$url
)

if (-not $url) {
    $url = $filename
    $filename = $res
    $res = ""
}

# Sanitize filename
$filename = $filename -replace '[\\/:*?"<>|]', '_'

# Output directory
$outputDir = "YT-DLP"
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Resolution mapping
$target = 0
switch ($res.ToLower()) {
    "4k"    { $target = 2160 }
    "2k"    { $target = 1440 }
    "1080p" { $target = 1080 }
    "720p"  { $target = 720 }
    "480p"  { $target = 480 }
}

$upper = $target + 1

# Format selector (FIXED)
if ($target -gt 0) {
    $format = "(bestvideo[vcodec=av01][width>=$target][width<$upper]/bestvideo[vcodec=avc1][width>=$target][width<$upper]/bestvideo[vcodec=vp9][width>=$target][width<$upper])+bestaudio/best"
} else {
    $format = "bestvideo+bestaudio/best"
}

# Subtitle detection
$subs = yt-dlp --list-subs "$url" 2>$null
$hasRealSub = $subs -match "^en " -and $subs -notmatch "auto-generated"

# Download
if ($hasRealSub) {
    yt-dlp -f $format --merge-output-format mkv --sub-lang en --write-subs --embed-subs `
        -o "$outputDir\$filename.mkv" "$url"
} else {
    yt-dlp -f $format --merge-output-format mkv `
        -o "$outputDir\$filename.mkv" "$url"
}

# Log
Add-Content yt-dlp-log.txt "[$(Get-Date)] Downloading $url as $filename.mkv"