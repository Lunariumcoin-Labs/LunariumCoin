#!/usr/bin/env bash
# LunariumCoin bootstrap launcher.
# Downloads and installs the official blockchain bootstrap on first run so the
# wallet starts already close to synced, then launches lunariumcoin-qt.
# Safe to run again later: if blocks are already present, the download is skipped.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$HOME/.lunariumcoin"
BLOCKS_DIR="$DATA_DIR/blocks"
BOOTSTRAP_URL="https://mundolunariumcoin.explorerxln.com/bootstrap/bootstrap-latest.tar.gz"
TMP_ZIP="$(mktemp -t lunariumcoin-bootstrap.XXXXXX.tar.gz)"
TMP_EXTRACT="$(mktemp -d -t lunariumcoin-bootstrap-extract.XXXXXX)"
WALLET_BIN="$SCRIPT_DIR/lunariumcoin-qt"

cleanup() {
    rm -f "$TMP_ZIP"
    rm -rf "$TMP_EXTRACT"
}
trap cleanup EXIT

has_existing_blockchain() {
    [ -d "$BLOCKS_DIR" ] && ls "$BLOCKS_DIR"/blk*.dat >/dev/null 2>&1
}

if has_existing_blockchain; then
    echo "Blockchain data already present, skipping bootstrap download."
else
    echo "==========================================================="
    echo " LunariumCoin - First run setup"
    echo "==========================================================="
    echo "No local blockchain data found."
    echo "Downloading the official bootstrap so you don't have to sync"
    echo "from scratch (~1.1 GB)."
    echo

    mkdir -p "$DATA_DIR"

    if command -v curl >/dev/null 2>&1; then
        DOWNLOAD_OK=1
        curl -L --fail --progress-bar -o "$TMP_ZIP" "$BOOTSTRAP_URL" || DOWNLOAD_OK=0
    elif command -v wget >/dev/null 2>&1; then
        DOWNLOAD_OK=1
        wget -O "$TMP_ZIP" "$BOOTSTRAP_URL" || DOWNLOAD_OK=0
    else
        echo "Neither curl nor wget found. Skipping bootstrap; the wallet will sync from scratch."
        DOWNLOAD_OK=0
    fi

    if [ "$DOWNLOAD_OK" = "1" ]; then
        echo "Download complete. Extracting..."
        if tar -xzf "$TMP_ZIP" -C "$TMP_EXTRACT"; then
            for folder in blocks chainstate sporks; do
                if [ -d "$TMP_EXTRACT/$folder" ]; then
                    rm -rf "${DATA_DIR:?}/$folder"
                    mv "$TMP_EXTRACT/$folder" "$DATA_DIR/$folder"
                fi
            done
            echo "Bootstrap installed successfully."
        else
            echo "Failed to extract the bootstrap archive. The wallet will sync from scratch."
        fi
    else
        echo "Bootstrap download failed. The wallet will still start, it will just sync from scratch over the network."
    fi
fi

echo "Starting LunariumCoin wallet..."
exec "$WALLET_BIN" "$@"
