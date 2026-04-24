param(
    [Parameter(Mandatory=$true)]
    [string]$file
)

# -------------------------------
# Get item safely (works for hidden/system)
# -------------------------------
$item = Get-Item $file -Force -ErrorAction SilentlyContinue

if (-not $item) {
    Write-Host "File or folder not found: $file" -ForegroundColor Red
    exit 1
}

# -------------------------------
# If folder → hide everything inside
# -------------------------------
if ($item.PSIsContainer) {

    Get-ChildItem $file -Recurse -Force | ForEach-Object {
        $_.Attributes = $_.Attributes `
            -bor [System.IO.FileAttributes]::Hidden `
            -bor [System.IO.FileAttributes]::System `
            -bor [System.IO.FileAttributes]::ReadOnly
    }
}

# -------------------------------
# Hide main item
# -------------------------------
$item.Attributes = $item.Attributes `
    -bor [System.IO.FileAttributes]::Hidden `
    -bor [System.IO.FileAttributes]::System `
    -bor [System.IO.FileAttributes]::ReadOnly

Write-Host "File/folder '$file' is now hidden (Hidden + System + ReadOnly)."
