param()

$components = Get-ChildItem "packages" | % { $_.Name.Replace(".tar.gz","") }
foreach($component in $components) {
    write-host "publishing $component"
    $shouldPublish = .\check-ocversion.ps1 -ocUrl $env:OC_REGISTRY -ocName $component
    if ($shouldPublish) {
        npx oc publish --skipPackage $component --registries $env:OC_REGISTRY --username $env:OC_USERNAME --password $env:OC_PASSWORD
    } else {
        write-host "version already exists. skipping."
    }
}