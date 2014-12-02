#!/bin/bash

set -e

BUNDLER_DIR=$(pwd)

CFFI_DIR="$BUNDLER_DIR/../sublime-cffi"
CRYPTOGRAPHY_DIR="$BUNDLER_DIR/../sublime-cryptography"
PYOPENSSL_DIR="$BUNDLER_DIR/../sublime-pyOpenSSL"

TAG_NAME=$1

if [[ $TAG_NAME == "" ]]; then
    echo "Usage: ./update.sh {tag_name}"
    exit 1
fi

BASE_URL="https://github.com/codexns/pyopenssl-build/releases/download"

TMP_DIR="$BUNDLER_DIR/tmp"

download_extract() {
    PLAT_ARCH="$1"
    ST_DIR="$2"

    if [[ -e $TMP_DIR/$PLAT_ARCH ]]; then
        rm -R $TMP_DIR/$PLAT_ARCH
    fi
    mkdir -p $TMP_DIR/$PLAT_ARCH

    cd $TMP_DIR/$PLAT_ARCH

    if [[ $PLAT_ARCH =~ linux ]]; then
        SUFFIX=".tar.gz"
        EXTRACT_COMMAND="tar xvfz"
        if [[ $PLAT_ARCH =~ 33 ]]; then
            SO_EXT=".cpython-33m.so"
        else
            SO_EXT=".so"
        fi
    elif [[ $PLAT_ARCH =~ osx ]]; then
        SUFFIX=".zip"
        EXTRACT_COMMAND="unzip"
        SO_EXT=".so"
    else
        SUFFIX=".zip"
        EXTRACT_COMMAND="unzip"
        SO_EXT=".pyd"
    fi

    ARCHIVE_NAME="${TAG_NAME}_${PLAT_ARCH}${SUFFIX}"

    curl -O --location $BASE_URL/$TAG_NAME/$ARCHIVE_NAME
    $EXTRACT_COMMAND $ARCHIVE_NAME
    rm $ARCHIVE_NAME

    if [[ -e $CFFI_DIR/$ST_DIR ]]; then
        rm -R $CFFI_DIR/$ST_DIR
    fi
    mkdir -p $CFFI_DIR/$ST_DIR

    mv _cffi_backend$SO_EXT $CFFI_DIR/$ST_DIR/
    mv cffi $CFFI_DIR/$ST_DIR/
    mv pycparser $CFFI_DIR/$ST_DIR/

    if [[ -e $CRYPTOGRAPHY_DIR/$ST_DIR ]]; then
        rm -R $CRYPTOGRAPHY_DIR/$ST_DIR
    fi
    mkdir -p $CRYPTOGRAPHY_DIR/$ST_DIR

    mv six.py $CRYPTOGRAPHY_DIR/$ST_DIR/
    mv cryptography $CRYPTOGRAPHY_DIR/$ST_DIR/

    if [[ -e $PYOPENSSL_DIR/$ST_DIR ]]; then
        rm -R $PYOPENSSL_DIR/$ST_DIR
    fi
    mkdir -p $PYOPENSSL_DIR/$ST_DIR

    mv OpenSSL $PYOPENSSL_DIR/$ST_DIR/

    cd $BUNDLER_DIR
}

download_extract py26_linux-x32   st2_linux_x32
download_extract py26_linux-x64   st2_linux_x64
download_extract py26_osx-x64     st2_osx_x64
download_extract py26_windows-x32 st2_windows_x32
download_extract py26_windows-x64 st2_windows_x64
download_extract py33_linux-x32   st3_linux_x32
download_extract py33_linux-x64   st3_linux_x64
download_extract py33_osx-x64     st3_osx_x64
download_extract py33_windows-x32 st3_windows_x32
download_extract py33_windows-x64 st3_windows_x64

