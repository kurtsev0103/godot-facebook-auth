#!/bin/bash

plugin_name=GodotFacebookAuth

godot_version=3.4

declare -a targets=(Release Debug)

# Checking the validity of version
function validating_version() {
  local version=${1}"-stable"

  cd ./godot || exit
  git pull
  if [ $(git tag -l $version) ]; then
    godot_version=${1}
  fi
  cd ./../
}

# Checking for input parameters
while getopts v: flag
do
  case ${flag} in
    v) validating_version ${OPTARG};;
  esac
done

echo "$(tput setaf 2)=== Selected Godot version $(tput setaf 1)$godot_version"-stable" $(tput setaf 2)===$(tput sgr 0)"

# Checking for scons version
if [ ${godot_version:0:1} = 4 ]; then
  scons_version=4.0
fi

# Checkout Godot version
cd ./godot || exit
git checkout $godot_version"-stable"

# Generate Headers
./../scripts/timeout.sh scons platform=iphone target=release_debug --jobs=$(sysctl -n hw.logicalcpu)
cd ./../

# Compile static libraries
for target in ${targets[@]}
do
  xcodebuild -target $plugin_name -configuration $target -sdk iphoneos ONLY_ACTIVE_ARCH=NO BUILD_DIR="./bin"
  xcodebuild -target $plugin_name -configuration $target -sdk iphonesimulator -arch x86_64 BUILD_DIR="./bin"

  output=release
  if [ $target = Debug ]; then
    output=debug
  fi

  lipo -create ./bin/$target"-iphoneos"/lib$plugin_name.a \
    ./bin/$target"-iphonesimulator"/lib$plugin_name.a -output \
    ./bin/$plugin_name.$output.a

  rm -r ./bin/$target"-iphonesimulator"
  rm -r ./bin/$target"-iphoneos"
done

# Archiving plugin
zip ./bin/"$plugin_name"_for_Godot_$godot_version.zip \
  ./bin/$plugin_name.release.a ./bin/$plugin_name.debug.a \
  ./$plugin_name.gdip \
  -r ./FacebookSDK

rm ./bin/$plugin_name.release.a
rm ./bin/$plugin_name.debug.a

echo "$(tput setaf 2)=== The plugin has been created in $(tput setaf 6)'bin' $(tput setaf 2)folder ===$(tput sgr 0)"
