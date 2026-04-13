param()

Write-Host "Listing all folders (including hidden ones) from the current directory..." -ForegroundColor Cyan

Get-ChildItem -Directory -Recurse -Force | ForEach-Object {
    $_.FullName
}