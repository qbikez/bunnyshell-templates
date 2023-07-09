param($skip = @("services/mysql"))

$composeFiles = Get-ChildItem -Recurse -Filter "docker-compose.yaml"

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

foreach ($compose in $composeFiles) {
  $yaml = Get-Content $compose.FullName | Out-String | ConvertFrom-Yaml
  if ($compose.DirectoryName -eq $pwd.Path) { 
    continue
  }
  $relDir = $compose.DirectoryName.Replace($pwd.Path, "").Replace("\", "/").Trim("/")
  if (@($skip) -contains $relDir) {
    write-host "skipping $relDir"
    continue
  }
  foreach ($service in $yaml.services.GetEnumerator()) {
    $newValue = rewrite-paths "services.$($service.name)" $service.Value $relDir
    $merged.services[$service.Key] = $newValue 
        
  }
}

$merged | ConvertTo-Yaml -Options WithIndentedSequences | Out-File "docker-compose.yaml"