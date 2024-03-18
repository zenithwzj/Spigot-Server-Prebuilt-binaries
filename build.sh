echo '[build] Downloading java8u401 archive ...'
curl -L https://javadl.oracle.com/webapps/download/AutoDL?BundleId=249542_4d245f941845490c91360409ecffb3b4 --output java8.tar.gz
if ! [ -e java8.tar.gz ] ;then
    >&2 echo '[build] Failed to download java8.tar.gz! The script is going to exit...'
    exit
fi
tar -zxf java8.tar.gz


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
../jre1.8.0_401/bin/java -jar BuildTools.jar --rev 1.8.2 
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