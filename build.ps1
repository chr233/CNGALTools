$zipName = "CNGALTOOLS.zip";
#输出路径
$distName = "dist";
#项目路径(需要含有.sln文件)
$projectFolders = 
"1.NVL\BKEngine\BKEngineUnpacker",
"1.NVL\NVLKrkr2\NvlKR2Extract",
"1.NVL\NVLKrkr2\NVLKrkrDump",
"1.NVL\NVLUnity\NVLUnityDecryptor",
"2.Strrationalism\Snowing\SnowingExtract",
"3.BlueAngel\BlueAngelExtract",
"4.Fontainebleau\MeetInParisDumper",
"6.iFAction\iFActionTool",
"999.Others\1.爱与命的彼端\SteamID1633470Decrypt";

$distFolder = Join-Path $PSScriptRoot $distName;

#切换到根目录
Set-Location $PSScriptRoot

#创建输出目录
if (!(Test-Path $distFolder)) {
  Write-Output "Create folder $distFolder";
  New-Item -ItemType Directory -Path $distFolder -Force | Out-Null;
}

#批量编译项目
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

      #创建输出目录
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
