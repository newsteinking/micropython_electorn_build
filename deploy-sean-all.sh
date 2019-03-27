#!/bin/bash
# See https://medium.com/@nthgergo/publishing-gh-pages-with-travis-ci-53a8270e87db
set -o errexit

rm -rf out
mkdir out

# config
git config --global user.email "newstein33@gmail.com"
git config --global user.name "newsteinking"

# build (CHANGE THIS)
mkdir editor
cd editor
mkdir scratch-gui
git clone https://github.com/newsteinking/SEANLABScratch3.0 scratch-gui-source
cd scratch-gui-source
npm install > /dev/null 2>&1
npm run build > /dev/null 2>&1
cp -r ./build/* ../
cd ../
rm -r -f "scratch-gui-source"

cd ../
echo "Win x64"
./node_modules/.bin/electron-packager . "Scratch3.0" --asar --platform win32 --arch x64 --out out --icon seanlablogo.ico --prune false
echo "Win x32"
./node_modules/.bin/electron-packager . "Scratch3.0" --asar --platform win32 --arch ia32 --out out --icon seanlablogo.ico --prune false
echo "Linux x64"
./node_modules/.bin/electron-packager . "Scratch3.0" --asar --platform linux --arch x64 --out out --icon seanlablogo.png --prune false
echo "Linux x32"
./node_modules/.bin/electron-packager . "Scratch3.0" --asar --platform linux --arch ia32 --out out --icon seanlablogo.png --prune false
echo "Linux ARM"
./node_modules/.bin/electron-packager . "Scratch3.0" --asar --platform linux --arch armv7l --out out --icon seanlablogo.png --prune false
echo "Mac x64"
./node_modules/.bin/electron-packager . "Scratch3.0" --asar --platform darwin --arch x64 --out out --icon icon.icns --prune false

# deploy
cd out
zip -r -q -9 Scratch3.0-Win32-x64.zip "Scratch3.0-win32-x64"
rm -r "Scratch3.0-win32-x64"
zip -r -q -9 Scratch3.0-Win32-ia32.zip "Scratch3.0-win32-ia32"
rm -r "Scratch3.0-win32-ia32"
tar -cvzf Scratch3.0-Linux-x64.tar.gz "Scratch3.0-linux-x64" > /dev/null 2>&1
rm -r "Scratch3.0-linux-x64"
tar -cvzf Scratch3.0-Linux-ia32.tar.gz "Scratch3.0-linux-ia32" > /dev/null 2>&1
rm -r "Scratch3.0-linux-ia32"
tar -cvzf Scratch3.0-Linux-armv7l.tar.gz "Scratch3.0-linux-armv7l" > /dev/null 2>&1
rm -r "Scratch3.0-linux-armv7l"
tar -cvzf Scratch3.0-Mac-x64.tar.gz "Scratch3.0-darwin-x64" > /dev/null 2>&1
rm -r "Scratch3.0-darwin-x64"
cp ../index.md ./
cp ../_config.yml ./
cp ../README-out.md ./README.md

git init
git lfs install
git lfs track *
git add .
git commit -m "Deploy to Github Pages"
#git push --force "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPO}.git" master:gh-pages
git push --force "https://github.com/newsteinking/Scratch3.0_build_out.git" master:master
exit 0
