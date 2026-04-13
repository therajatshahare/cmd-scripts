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

# -------------------------------
# Apply hidden + system + read-only
# -------------------------------
$item = Get-Item $file

$item.Attributes = $item.Attributes `
    -bor [System.IO.FileAttributes]::Hidden `
    -bor [System.IO.FileAttributes]::System `
    -bor [System.IO.FileAttributes]::ReadOnly

Write-Host "File '$file' is now hidden (Hidden + System + ReadOnly)."