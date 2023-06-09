param($skip = @("services/mysql", "apps/open-components/oc-registry"))

$composeFiles = Get-ChildItem -Recurse -Filter "docker-compose.yaml" | sort FullName

$merged = [ordered]@{
  version  = "3.7"
  services = @{}
}

req powershell-yaml

function rewrite-paths([string]$parentKeyPath, [hashtable]$hashtable, [string]$relDir) {
  $newValues = @{}
  if ([string]::IsNullOrEmpty($relDir)) {
    throw "relDir is missing"
  }

  foreach ($kvp in $hashtable.GetEnumerator()) {
    if ([string]::IsNullOrEmpty($kvp.value)) {
      throw "$($kvp.key) value is missing"
    }
    $keypath = "$parentKeyPath.$($kvp.Key)"
    if ($kvp.Value.GetType().Name -eq "Hashtable") {
      write-host "recursing $keypath"
      $newValues[$kvp.key] = rewrite-paths $keypath $kvp.Value $relDir
    }
    else {
      switch ($keypath) {
        { $_.EndsWith(".build") -or $_.EndsWith(".env_file") } {
          if ($kvp.Value.GetType().Name -ne "String") {
            $s = $kvp.value | Format-Table | Out-String 
            Write-Host "'$s'"
            throw "$keypath value is not a string it's a $($kvp.Value.GetType().Name)"
          }
      
          $newValue = (Join-Path -Path $relDir -ChildPath $kvp.Value).Replace("\", "/").TrimStart("/")
          $newValues[$kvp.Key] = $newValue
        }
        { $_.EndsWith(".build.context") } {
          if ($kvp.Value.GetType().Name -ne "String") {
            throw "$keypath value is not a string it's a $($kvp.Value.GetType().Name)"
          }
      
          $newValue = (Join-Path -path $relDir -ChildPath $kvp.Value).Replace("\", "/").TrimStart("/")
          $newValues[$kvp.Key] = $newValue
        }
      }
    }
  }

  foreach ($kvp in $newValues.GetEnumerator()) {
    write-host "setting $parentKeyPath.$($kvp.Key) = $($kvp.Value)"
    $hashtable[$kvp.Key] = $kvp.Value
  }

  return $hashtable
}

$workingDir = $pwd.Path
$mergedEnv = [ordered]@{}

foreach ($compose in $composeFiles) {
  if ($compose.DirectoryName -eq $workingDir) { 
    continue
  }
  $relDir = $compose.DirectoryName.Replace($workingDir, "").Replace("\", "/").Trim("/")
  
  
  if (@($skip) -contains $relDir) {
    write-verbose "skipping $relDir" -verbose
    continue
  }
  write-verbose "processing $($relDir)" -Verbose
  
  $yaml = Get-Content $compose.FullName | Out-String | ConvertFrom-Yaml

  foreach ($service in $yaml.services.GetEnumerator()) {
    $newValue = rewrite-paths "services.$($service.name)" $service.Value $relDir
    $merged.services[$service.Key] = $newValue         
  }

  if (test-path "$($compose.DirectoryName)/.env") {
    $env = Get-Content "$($compose.DirectoryName)/.env"
    $env | ForEach-Object {
      if ($_ -match "^\s*([^=]+)\s*=\s*(.*)\s*$") {
        $key = $matches[1]
        $value = $matches[2]
        $mergedEnv.$key = $value
      }
    }
  }
}

$merged | ConvertTo-Yaml -Options WithIndentedSequences | Out-File "docker-compose.yaml"
$envFile = @()
foreach($kvp in $mergedEnv.GetEnumerator()) {
  $envFile += "$($kvP.Key)=$($kvp.Value)"
}
$envFile | Out-File ".env"