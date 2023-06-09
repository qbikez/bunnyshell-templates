param($componentsDir = "components", $registryUrl = "http://localhost:3000/registry", $username, $password)


pushd $componentsDir

try {
    $components = Get-ChildItem -Directory | % { $_.Name }

    foreach ($component in $components) {
        write-host "publishing $component to $registryUrl"
        $shouldPublish = & "$psscriptroot/check-ocversion.ps1" -ocUrl $registryUrl -ocName $component
        if ($shouldPublish) {
            npx oc publish --skipPackage $component --registries $registryUrl --username $username --password $password
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