#!/usr/bin/env bash

set -e

if ! command -v img2pdf &> /dev/null; then
	echo "img2pdf is not installed or not in your PATH!"
	exit 1
fi

if [ "$#" -lt 1 ]; then
	echo "Illegal number of arguments"
	echo "Requested arguments: <input file> [author] [title]"
	exit 1
fi

ARCHIVE=$1
if [ ! -r "${ARCHIVE}" ]; then
	echo "Invalid input file"
	exit 1
fi

if [[ "$ARCHIVE" == *.cbz ]]; then
	FORMAT=".cbz"
elif [[ "$ARCHIVE" == *.cbt ]]; then
	FORMAT=".cbt"
elif [[ "$ARCHIVE" == *.cb7 ]]; then
	FORMAT=".cb7"
else
	echo "Supported formats are CBZ, CBT, and CB7."
	exit 1
fi

echo "Creating work directory…"

EXTRACT_DIR=$(mktemp -d)
function cleanup {
	rm -rf "$EXTRACT_DIR"
	echo "(Deleted work directory $EXTRACT_DIR)"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

echo "Extracting archive to work directory…"
tar xf "$ARCHIVE" -C "$EXTRACT_DIR"

DIRNAME=$(dirname "$ARCHIVE")
FNAME_NO_EXT=$(basename "$ARCHIVE" "$FORMAT")
AUTHOR=${2:-""}
TITLE=${3:-$FNAME_NO_EXT}

echo "Creating PDF file…"
shopt -s globstar nullglob

OUTFILE="$DIRNAME/$TITLE.pdf"

img2pdf -o "$OUTFILE" --title "$TITLE" --subject "$TITLE" --author "$AUTHOR" --creator "$AUTHOR" --viewer-fit-window "$EXTRACT_DIR"/**/*.{jpg,png}

echo "Created $TITLE.pdf"