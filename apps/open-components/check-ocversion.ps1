param(
    $ocUrl, 
    $ocName,
    $autoupdate = $true
)

$VerbosePreference = "Continue"

$existingVersion = $null
$latestVersion = $null
$failWhenVersionExists = $failWhenExists -eq "true"

$json = get-content $ocName/package.json | out-string | convertfrom-json
$versionFromFile = [Version]$json.version
$ocVersion = $versionFromFile

write-host "version from package.json: $versionFromFile"

try { 
    $registry = $ocUrl.TrimEnd("/")
    $info = Invoke-RestMethod -Method get -UseBasicParsing "$registry/$ocName/~info"
    $existingVersion = $info.allVersions | ? { $_ -eq $ocVersion }
    $latestVersion = [Version]::Parse($info.version)
}
catch { 
    if ($_.exception.response.statuscode -eq 404) {
        $latestVersion = [Version]::Parse("0.0.0")
        $existingVersion = $null
    }
    else {
        throw
    }
}

write-host "latest version in registry: $latestVersion"

$versionExists = $latestVersion -ge $ocVersion
$shouldPublish = !$versionExists

if ($versionExists -and $autoupdate) {
    $build = $latestVersion.Build + 1
    $newVersion = (New-Object -Type Version ($versionFromFile.Major, $versionFromFile.Minor, $build))
    $json.version = "$($newVersion.Major).$($newVersion.Minor).$($newVersion.Build)"
    write-host "updating version in package.json to $($json.version)"
    $json | convertto-json -depth 100 | set-content $ocName/package.json
    return $true
} else {
    return $shouldPublish 
}

# $buildVersion = [Version]::Parse($ocVersion) 
# 

# echo "##vso[task.setvariable variable=$outputVariable]$versionExists"

# if ($versionExists) {
#     $message = "component $ocName v$buildVersion already exists in registry '$registry'"
#     if ($failWhenVersionExists -eq "true") {
#         echo "##vso[task.logissue type=error;]$message"
#         throw $message
#     }
#     else {
#         write-warning $message
#         echo "##vso[task.setvariable variable=$outputVariable]$versionExists"
#         echo "##vso[task.logissue type=warning;]$message"
#     }
# }    