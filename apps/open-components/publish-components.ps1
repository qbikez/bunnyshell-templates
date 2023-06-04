param($components = "hello-world")

foreach($component in $components) {
    $shouldPublish = .\check-ocversion.ps1 -ocUrl $env:OC_REGISTRY -ocName $component
    if ($shouldPublish) {
        write-host "publishing $component"
        npx oc publish $component --registries $env:OC_REGISTRY --username $env:OC_USERNAME --password $env:OC_PASSWORD
    }
}