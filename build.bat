@echo off
echo [build.bat] Downloading openjdk17.zip ...
curl -L https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_windows-x64_bin.zip --output openjdk17.zip
if not exist openjdk17.zip (
    echo [build.bat] Failed to download openjdk17.zip! The script is going to exit...
    exit
)
echo [build.bat] Unpacking openjdk17.zip ...
tar -xf openjdk17.zip
del /F /Q openjdk17.zip

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
..\jdk-17.0.2\bin\java -jar BuildTools.jar --rev 1.19 
if not exist spigot-1.19.jar (
    echo [build.bat] Error Building Spigot! The script is going to exit...
    exit
) else echo [build.bat] Build success!
cd ..

echo [build.bat] Exporting built artifacts ...
move /Y SPBuild\spigot-1.19.jar .\ >nul
echo [build.bat] Removing src ...
rd /S /Q SPBuild