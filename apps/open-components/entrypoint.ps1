# start oc registry and publish components
$proc = Start-Process "npm" -ArgumentList "start" -WorkingDirectory "oc-registry" -PassThru

$registryStarted = $false
do {
    Write-Host "Waiting for oc registry to start..."
    try {
    $resp = Invoke-RestMethod -Uri "http://localhost:3000/registry/" -Method Get -ErrorAction Stop
    $registryStarted = $true
    } catch {
        Write-Error $_
        Start-Sleep -Seconds 1
    }
} while (!$registryStarted)

./package-components.ps1
./publish-components.ps1 -username $env:APPSETTING_REGISTRY_USERNAME -password $env:APPSETTING_REGISTRY_PASSWORD

Stop-Process $proc.Id
Get-Process node -ErrorAction Continue | Stop-Process


# start oc registry again, this time as foreground process
cd oc-registry
npm start
