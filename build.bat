@echo off
echo [build.bat] Downloading openjdk21.zip ...
curl -L https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_windows-x64_bin.zip --output openjdk21.zip
if not exist openjdk21.zip (
    echo [build.bat] Failed to download openjdk21.zip! The script is going to exit...
    exit
)
echo [build.bat] Unpacking openjdk21.zip ...
tar -xf openjdk21.zip
del /F /Q openjdk21.zip

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
..\jdk-21.0.2\bin\java -jar BuildTools.jar --rev 1.19.2 
if not exist spigot-1.19.2.jar (
    echo [build.bat] Error Building Spigot! The script is going to exit...
    exit
) else echo [build.bat] Build success!
cd ..

echo [build.bat] Exporting built artifacts ...
move /Y SPBuild\spigot-1.19.2.jar .\ >nul
echo [build.bat] Removing src ...
rd /S /Q SPBuild