echo '[build] Downloading openjdk-21.0.2 archive ...'
curl -L https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz --output openjdk-21.0.2.tar.gz
if ! [ -e openjdk-21.0.2.tar.gz ] ;then
    >&2 echo '[build] Failed to download openjdk-21.0.2.tar.gz! The script is going to exit...'
    exit
fi
tar -zxf openjdk-21.0.2.tar.gz


echo '[build] Downloading BuildTools.jar ...'
curl -L https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar --output BuildTools.jar
if ! [ -e BuildTools.jar ] ;then
    >&2 echo '[build] Failed to download BuildTools.jar! The script is going to exit...'
    exit
fi

echo '[build] Creating workspace for Spigot Builder ...'
2>/dev/null mkdir SPBuild
mv -f BuildTools.jar SPBuild >/dev/null
cd SPBuild

echo [build] Building Spigot...
../jdk-21.0.2/bin/java -jar BuildTools.jar --rev 1.21.1
if ! [ -e spigot-*.jar ] ;then
    >&2 echo '[build] Error Building Spigot! The script is going to exit...'
    exit
fi
echo '[build] Build success!'
cd ..

echo '[build] Exporting built artifacts ...'
mv -f SPBuild/spigot-*.jar . >/dev/null
echo '[build] Removing src ...'
rm -rf SPBuild
echo '[build] Renaming artifact ...'
mv -f spigot-*.jar spigot.jar
