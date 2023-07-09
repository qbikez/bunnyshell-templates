pushd "$psscriptroot/../terraform"

function set-dotenv($path, $name, $value) {
    write-verbose "setting [$path] $name=$value" -verbose
    $envPath = "$path"
    if (!(Test-Path $envPath)) {
        New-Item $envPath -ItemType file
    }

    $env = Get-Content $envPath
    $env = $env | ForEach-Object {
        if ($_ -match "^\s*$name\s*=\s*") {
            "$name=`"$value`""
        } else {
            $_
        }
    }

    $env | Out-File -FilePath $envPath
}

try {
    $outputs = terraform output -json | ConvertFrom-Json
} finally {
    popd
}
set-dotenv "apps/node/payment-service/.env" "SERVICEBUS_CONNECTION_STRING" $outputs.servicebus_connectionstring.value
