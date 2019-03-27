#!/bin/bash
# See https://github.com/newsteinking/scratch3.0_electron_build
set -o errexit

rm -rf out
mkdir out

# config
git config --global user.email "newstein33@gmail.com"
git config --global user.name "newstein33"

# build (CHANGE THIS)
mkdir editor
cd editor
mkdir microbit-gui
git clone https://github.com/newsteinking/makecode.git  microbit-gui-source
cd microbit-gui-source
npm install > /dev/null 2>&1
#npm build:all  > /dev/null 2>&1
cd ..
mkdir build
cp -r ./microbit-gui-source/* ./build/
rm -r -f "microbit-gui-source"

cd ../
echo "Win x64"
./node_modules/.bin/electron-packager ./editor/build/ "Microbit3.0" --asar --platform win32 --arch x64 --out out --icon micro-bit-logo.ico --prune false
echo "Win x32"
./node_modules/.bin/electron-packager ./editor/build/ "Microbit3.0" --asar --platform win32 --arch ia32 --out out --icon micro-bit-logo.ico --prune false
echo "Linux x64"
./node_modules/.bin/electron-packager ./editor/build/ "Microbit3.0" --asar --platform linux --arch x64 --out out --icon micro-bit-logo.png --prune false
echo "Linux x32"
./node_modules/.bin/electron-packager ./editor/build/ "Microbit3.0" --asar --platform linux --arch ia32 --out out --icon micro-bit-logo.png --prune false
echo "Linux ARM"
./node_modules/.bin/electron-packager ./editor/build/ "Microbit3.0" --asar --platform linux --arch armv7l --out out --icon micro-bit-logo.png --prune false
echo "Mac x64"
./node_modules/.bin/electron-packager ./editor/build/ "Microbit3.0" --asar --platform darwin --arch x64 --out out --icon icon.icns --prune false

# deploy
cd out
zip -r -q -9 MicrobitWin32-x64.zip "Microbit3.0-win32-x64"
rm -r "Microbit3.0-win32-x64"
zip -r -q -9 MicrobitWin32-ia32.zip "Microbit3.0-win32-ia32"
rm -r "Microbit3.0-win32-ia32"
tar -cvzf MicrobitLinux-x64.tar.gz "Microbit3.0-linux-x64" > /dev/null 2>&1
rm -r "Microbit3.0-linux-x64"
tar -cvzf MicrobitLinux-ia32.tar.gz "Microbit3.0-linux-ia32" > /dev/null 2>&1
rm -r "Microbit3.0-linux-ia32"
tar -cvzf MicrobitLinux-armv7l.tar.gz "Microbit3.0-linux-armv7l" > /dev/null 2>&1
rm -r "Microbit3.0-linux-armv7l"
tar -cvzf MicrobitMac-x64.tar.gz "Microbit3.0-darwin-x64" > /dev/null 2>&1
rm -r "Microbit3.0-darwin-x64"
#cp ../index.md ./
#cp ../_config.yml ./
#git init
#git lfs install
#git lfs track *
#git add .
#git commit -m "Deploy to Github Pages"
#git push --force "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git" master:gh-pages
exit 0
