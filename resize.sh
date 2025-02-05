#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No filename provided."
  echo "Usage: $0 <filename.vpx>"
  exit 1
fi

filename=$1

if [ ! -f "$filename" ]; then
  echo "Error: File '$filename' does not exist."
  exit 1
fi

if [[ "$filename" != *.vpx ]]; then
  echo "Error: File '$filename' does not have a .vpx extension."
  exit 1
fi

dirname="${filename%.vpx}"

if [ -d "$dirname" ]; then
  echo "Error: Directory '$dirname' already exists. Please remove or rename it before proceeding."
  exit 1
fi

output="${filename%.vpx}-resized.vpx"

if [ -f "$output" ]; then
  echo "Error: Output file '$output' already exists. Please remove or rename it before proceeding."
  exit 1
fi

vpxtool extract "$filename"

cd "$dirname/images"
for file in *.exr *.webp *.png *.jpg *.jpeg *.hdr; do
  lower_name=$(basename "$file" | tr '[:upper:]' '[:lower:]')
  if [[ $lower_name == colorgrade* || $lower_name == *lut* ]]; then
    echo "skipping $file"
  else
    magick "$file" -resize 25% "$file"
  fi
done
cd ../..

vpxtool assemble "$dirname" "$output"

rm -rf "$dirname"
