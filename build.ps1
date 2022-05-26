$zipName = "CNGALTOOLS.zip";

$distName = "dist";


$distFolder = Join-Path $PSScriptRoot $distName;

Set-Location $PSScriptRoot

if (!(Test-Path $distFolder)) {
  Write-Output "Create folder $distFolder";
  New-Item -ItemType Directory -Path $distFolder -Force | Out-Null;
}

$slnFiles = Get-ChildItem -Path $PSScriptRoot -Recurse -Include "*.sln";

foreach ($slnFile in $slnFiles) {

  Write-Output "###############################################################";

  $projName = (Get-Item $slnFile).Name;

  $projPath = (Get-Item $slnFile).Directory;

  Set-Location $projPath;

  Write-Output "Start build [$projName] $proj";
  try {
    dotnet restore $slnFile;

    MSBuild.exe --nologo --restore --property:Configuration=Release;
    Write-Output "Build complete.";
  }
  catch {
    Write-Output "Build error.";
  }

  $exes = Get-ChildItem $projPath -Recurse -Include "*.exe"

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
