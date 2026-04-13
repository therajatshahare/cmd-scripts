param()

Write-Host "Checking for Winget updates..." -ForegroundColor Cyan
winget upgrade --include-unknown

Write-Host ""
Write-Host "Checking for Scoop updates..." -ForegroundColor Cyan
scoop update
scoop status

Write-Host ""
Read-Host "Press Enter to continue..."