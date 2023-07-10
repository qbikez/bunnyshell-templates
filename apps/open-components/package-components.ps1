param($componentDir = "components", $registryUrl = "http://localhost:3000/registry")

pushd $componentDir

try {
    $components = Get-ChildItem -Directory | % { $_.Name }

    foreach ($component in $components) {
        & "$psscriptroot/check-ocversion.ps1" -ocUrl $registryUrl -ocName $component
        npx oc package $component --compress --useComponentDependencies
    }
}
finally {
    popd
}