@echo off
@REM echo [build.bat] Downloading openjdk16.zip ...
@REM curl -L https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_windows-x64_bin.zip --output openjdk16.zip
@REM if not exist openjdk16.zip (
@REM     echo [build.bat] Failed to download openjdk16.zip! The script is going to exit...
@REM     exit
@REM )
@REM echo [build.bat] Unpacking openjdk16.zip ...
@REM tar -xf openjdk16.zip
@REM del /F /Q openjdk16.zip

echo [build.bat] Downloading BuildTools.jar ...
curl -L https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar --output BuildTools.jar
if not exist BuildTools.jar (
    echo [build.bat] Failed to download BuildTools.jar! The script is going to exit...
    exit
)

echo [build.bat] Creating workspace for Spigot Builder ...
2>nul md SPBuild
move /Y BuildTools.jar SPBuild >nul
cd SPBuild

echo [build.bat] Building Spigot...
java -jar BuildTools.jar --rev 1.9.2 
if not exist spigot-1.9.2.jar (
    echo [build.bat] Error Building Spigot! The script is going to exit...
    exit
) else echo [build.bat] Build success!
cd ..

echo [build.bat] Exporting built artifacts ...
move /Y SPBuild\spigot-1.9.2.jar .\ >nul
echo [build.bat] Removing src ...
rd /S /Q SPBuild