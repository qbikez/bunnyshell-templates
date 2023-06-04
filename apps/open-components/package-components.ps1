param($components = "hello-world")

if (!(test-path packages)) {
    mkdir packages
}

foreach($component in $components) {
   npx oc package $component --compress --useComponentDependencies
   cp $component/package.tar.gz packages/$component.tar.gz
}