[CmdletBinding()]
param (
    [ValidateSet("terraform", "cache")]
    $source = "terraform"
)

pushd "$psscriptroot/../terraform"

function set-json($path, $key, $value) {
    write-verbose "setting [$path] $key=$value" -verbose

    if (!(Test-Path $path)) {
        New-Item $path -ItemType file
    }

    $json = Get-Content $path | ConvertFrom-Json
    if ($json -eq $null) {
        $json = @{}
    }
    $components = $key.Split(":")

    $node = $json
    for($i = 0; $i -lt $components.Length - 1; $i++) {
        $component = $components[$i]
        if ($node.$component -eq $null) {
            $parent = $node
            $node = New-Object -TypeName PSCustomObject
            $parent | Add-Member -MemberType NoteProperty -Name $component -Value $node
        } else {
            $node = $node.$component
        }
    }

    $component = $components[$components.Length - 1]
    if ($node.$component -eq $null) {
        $node | Add-Member -MemberType NoteProperty -Name $component -Value $value
    }
    $node.$component = $value
    
    $json | ConvertTo-Json -Depth 100 | Out-File $path
}

function set-dotenv($path, $key, $value) {
    write-verbose "setting [$path] $key=$value" -verbose
    $envPath = "$path"
    if (!(Test-Path $envPath)) {
        New-Item $envPath -ItemType file
    }

    $env = Get-Content $envPath
    $found = $false
    $env = $env | ForEach-Object {
        if ($_ -match "^\s*$key\s*=\s*") {
            "$key=`"$value`""
            $found = $true
        } else {
            $_
        }
    }

    if (!$found) {
        $env += "$key=`"$value`""
    }

    $env | Out-File -FilePath $envPath
}

try {
    if ($source -eq "terraform") {
        $outputs = terraform output -json | ConvertFrom-Json
        $outputs | ConvertTo-Json -Depth 100 | Out-File ".terraform-outputs.json"
    } elseif ($source -eq "cache") {
        $outputs = Get-Content ".terraform-outputs.json" | ConvertFrom-Json
    }
} finally {
    popd
}
set-dotenv "apps/payments/.env" "SERVICEBUS_CONNECTIONSTRING" $outputs.servicebus_connectionstring.value
set-json "apps/orders/appsettings.local.json" "ConnectionStrings:ServiceBus" $outputs.servicebus_connectionstring.value
set-dotenv "apps/orders/.env" "ConnectionStrings__ServiceBus" $outputs.servicebus_connectionstring.value