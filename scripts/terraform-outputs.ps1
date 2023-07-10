pushd "$psscriptroot/../terraform"

function set-json($path, $key, $value) {
    write-verbose "setting [$path] $key=$value" -verbose
    $json = Get-Content $path | ConvertFrom-Json
    $components = $key.Split(":")

    $node = $json
    for($i = 0; $i -lt $components.Length - 1; $i++) {
        $component = $components[$i]
        if ($node.$component -eq $null) {
            $node | Add-Member -MemberType NoteProperty -Name $component -Value @{}
        }
        $node = $node.$component
    }

    $node.$($components[$components.Length - 1]) = $value
    
    $json | ConvertTo-Json -Depth 100 | Out-File $path
}
function set-dotenv($path, $key, $value) {
    write-verbose "setting [$path] $key=$value" -verbose
    $envPath = "$path"
    if (!(Test-Path $envPath)) {
        New-Item $envPath -ItemType file
    }

    $env = Get-Content $envPath
    $env = $env | ForEach-Object {
        if ($_ -match "^\s*$key\s*=\s*") {
            "$key=`"$value`""
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
set-dotenv "apps/node/payment-service/.env" "SERVICEBUS_CONNECTIONSTRING" $outputs.servicebus_connectionstring.value
set-json "apps/dotnet/my-api/appsettings.Development.json" "ConnectionStrings:ServiceBus" $outputs.servicebus_connectionstring.value
set-dotenv "apps/dotnet/my-api/.env" "ConnectionStrings__ServiceBus" $outputs.servicebus_connectionstring.value