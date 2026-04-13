param()

Write-Host "Installing all Winget updates..." -ForegroundColor Cyan
winget upgrade --all `
    --include-unknown `
    --silent `
    --accept-package-agreements `
    --accept-source-agreements

Write-Host ""
Write-Host "Updating Scoop and all installed Scoop apps..." -ForegroundColor Cyan
scoop update *
    
Write-Host ""
Read-Host "Press Enter to continue..."