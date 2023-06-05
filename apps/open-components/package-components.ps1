param($componentDir = "components")

pushd $componentDir

try {
    $components = Get-ChildItem -Directory | % { $_.Name }

    foreach ($component in $components) {
        npx oc package $component --compress --useComponentDependencies
    }
}
finally {
    popd
}