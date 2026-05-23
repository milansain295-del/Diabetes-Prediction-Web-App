<#
Usage:
  In PowerShell, from the repo root run:
    .\git_push.ps1
  To use SSH instead of HTTPS:
    .\git_push.ps1 -useSsh

This script will remove any existing `origin`, add the correct origin, set branch to `main`,
and push. For HTTPS you'll be prompted for GitHub credentials; use a Personal Access Token as the password.
#>
param(
    [string]$remoteUrl = 'https://github.com/milansain295-del/Diabetes-Prediction-Web-App.git',
    [switch]$useSsh
)

function Run-Git {
    git $args
    if ($LASTEXITCODE -ne 0) { throw "Git command failed: git $args" }
}

try {
    Write-Host "Removing existing origin (if any)..."
    git remote get-url origin 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Run-Git remote remove origin
    }
} catch {
    # ignore if origin doesn't exist
}

if ($useSsh) {
    $url = 'git@github.com:milansain295-del/Diabetes-Prediction-Web-App.git'
} else {
    $url = $remoteUrl
}

Write-Host "Adding origin: $url"
Run-Git remote add origin $url

Write-Host "Setting branch to 'main'"
Run-Git branch -M main

Write-Host "Pushing to origin main (you may be prompted for credentials)..."
Run-Git push -u origin main

Write-Host "Done. If push failed due to authentication, create a PAT or set up SSH and re-run with -useSsh."
