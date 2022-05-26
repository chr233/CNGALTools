$zipName = "CNGALTOOLS.zip";

$distName = "dist";

$projectFolders = 
"1.NVL\BKEngine\BKEngineUnpacker",
"1.NVL\NVLKrkr2\NvlKR2Extract",
"1.NVL\NVLKrkr2\NVLKrkrDump",
"1.NVL\NVLUnity\NVLUnityDecryptor",
"2.Strrationalism\Snowing\SnowingExtract",
"3.BlueAngel\BlueAngelExtract",
"4.Fontainebleau\MeetInParisDumper",
"6.iFAction\iFActionTool";

$distFolder = Join-Path $PSScriptRoot $distName;

Set-Location $PSScriptRoot

if (!(Test-Path $distFolder)) {
  Write-Output "Create folder $distFolder";
  New-Item -ItemType Directory -Path $distFolder -Force | Out-Null;
}

foreach ($proj in $projectFolders) {

  continue;

  Write-Output "###############################################################";

  $fullPath = Join-Path $PSScriptRoot $proj;

  if (!(Test-Path $fullPath)) {
    Write-Output "Project $proj not found";
    continue;
  }

  $projName = (Get-Item $fullPath).Name;

  Set-Location $fullPath;

  Write-Output "Start build [$projName] $proj";
  MSBuild.exe --nologo --restore --property:Configuration=Release;
  Write-Output "Build complete.";

  $exes = Get-ChildItem $fullPath -Recurse -Include "*.exe"

  Write-Output "Copy binariy files";

  $copyCount = 0;

  foreach ($exe in $exes) {
    $exeName = $exe.BaseName;
    $exeFolder = (Get-Item $exe.PSPath).Directory;

    if ($exeFolder.Name -like "Release") {

      $distExePath = Join-Path $distFolder $exeName;

      if (!(Test-Path $distExePath)) {
        Write-Output "Create folder $distExePath";
        New-Item -ItemType Directory -Path $distExePath -Force | Out-Null;
      }

      Write-Output "Copy $exeFolder -> $distFolder";
      $files = Get-ChildItem $exeFolder -Exclude "*.cache", "*.csproj.*" , "*.cs";
      foreach ($file in $files) {
        Copy-Item -Path $file.FullName -Destination $distExePath -Force;
        $copyCount++;
      }
    }
  }

  Write-Output "Copied $copyCount files";
}

# Create the final zip file
7z a -bd -slp -tzip -mm=Deflate -mx=9 -mfb=258 -mpass=15 "$distFolder\$zipName" "$distFolder\*";

Write-Output "Script run finished";

Exit;
