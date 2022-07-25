#!/bin/bash
cd "$(dirname "$0")"

function download_compat {
    if [[ "$AZ_CACHE" != "" ]]
    then
        download_id=$(echo "$2" | md5sum | sed 's/ .*//g')
        if [[ -e "$AZ_CACHE/$3/$download_id" ]]
        then
            echo "Cache hit: $AZ_CACHE/$3/$download_id"
            cp "$AZ_CACHE/$3/$download_id" "$1"
            return
        elif [[ "$3" != "" ]]
        then
            rm -r "$AZ_CACHE/$3" 2> /dev/null
        fi
    fi
    if [[ "$(which wget 2>/dev/null)" != "" ]]
    then
        wget -qO "$1" "$2"
    else [[ "$(which curl)" != "" ]]
        curl -sL "$2" > "$1"
    fi
    if [[ "$AZ_CACHE" != "" ]]
    then
        echo "Saving to: $AZ_CACHE/$3/$download_id"
        mkdir -p "$AZ_CACHE/$3/"
        cp "$1" "$AZ_CACHE/$3/$download_id"
    fi
}

# Download web client
mkdir -p build

echo "Downloading web client..."
download_compat dist.zip "https://github.com/tingv/jellyfin-web-jmp/releases/download/TMP/dist.zip" "wc"
if [[ "$DOWNLOAD_ONLY" != "1" ]]
then
    rm -r build/dist 2> /dev/null
    rm -r dist 2> /dev/null
    unzip dist.zip > /dev/null && rm dist.zip
    mv dist build/
fi
echo "Download completed"

