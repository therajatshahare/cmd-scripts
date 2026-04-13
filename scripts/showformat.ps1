param(
    [Parameter(Mandatory=$true)]
    [string]$url
)

# -------------------------------
# Show available formats
# -------------------------------
yt-dlp --list-formats "$url"