GAME_NAME="jamfest-2026"
DIST_NAME="${DIST_NAME:-$GAME_NAME}"

ponies build -t "$TOOLCHAIN" -p release

[ -d "$DIST" ] && rm -r "$DIST"
mkdir -p "$DIST"

# Arguments: $1 = folder name, $2 = extension
function copy_resources() {
    if [[ -d "$1" ]]; then 
        mkdir -p "$DIST/$1"
        find "$1" -name "*.$2" -exec cp {} "$DIST/$1" \;
    else
        echo "no resource directory $1"
    fi
}

copy_resources sound wav
copy_resources sound ogg
copy_resources tex   png
copy_resources font  ttf

if [[ "$PLATFORM" == "web" ]]; then
    cp web/index.html      "$DIST"
    cp web/mq_js_bundle.js "$DIST"
fi

cp ".build/$TOOLCHAIN-release/game${SRCEXT}" "$DIST/${DIST_NAME}${EXT}"

# When manually creating zip files, we can use this, but if we're
# pushing with butler, there's actually no reason to create zips.
#
# rm -f ".build/$PLATFORM.zip"
# (cd $DIST && zip -r "../$PLATFORM.zip" .)