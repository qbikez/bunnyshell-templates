param($skip = @("services/mysql"))

$composeFiles = Get-ChildItem -Recurse -Filter "docker-compose.yaml"

$merged = [ordered]@{
  version  = "3.7"
  services = @{}
}

req powershell-yaml

function rewrite-paths([string]$parentKeyPath, [hashtable]$hashtable, [string]$relDir) {
  $newValues = @{}

  foreach ($kvp in $hashtable.GetEnumerator()) {
    $keypath = "$parentKeyPath.$($kvp.Key)"
    if ($kvp.Value.GetType().Name -eq "Hashtable") {
      $newValues[$kvp.key] = rewrite-paths $keypath $kvp.Value $relDir
    }
    else {
      switch ($keypath) {
        { $_.EndsWith(".build") -or $_.EndsWith(".env_file") } {
          $newValue = (Join-Path $relDir $kvp.Value).Replace("\", "/").TrimStart("/")
          $newValues[$kvp.Key] = $newValue
        }
        { $_.EndsWith(".build.context") } {
          $newValue = (Join-Path $relDir $kvp.Value).Replace("\", "/").TrimStart("/")
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
    $newValue = rewrite-paths "services.$($service.name)" $service.Value  $relDir
    $merged.services[$service.Key] = $newValue 
        
  }
}

$merged | ConvertTo-Yaml -Options WithIndentedSequences | Out-File "docker-compose.yaml"