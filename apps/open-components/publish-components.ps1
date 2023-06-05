param($componentsDir = "components")


pushd $componentsDir

try {
    $components = Get-ChildItem -Directory | % { $_.Name }

    foreach ($component in $components) {
        write-host "publishing $component to $env:OC_REGISTRY"
        $shouldPublish = & "$psscriptroot/check-ocversion.ps1" -ocUrl $env:OC_REGISTRY -ocName $component
        if ($shouldPublish) {
            npx oc publish --skipPackage $component --registries $env:OC_REGISTRY --username $env:OC_USERNAME --password $env:OC_PASSWORD
            if ($LASTEXITCODE -ne 0) {
                throw "failed to publish component $component"
            }
        }
        else {
            write-host "version already exists. skipping."
        }
    }
}
finally {
    popd
}