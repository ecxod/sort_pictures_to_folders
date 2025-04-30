#!/bin/bash

ANZAHL=100
ENDUNGEN="bmp jpg jpeg png webp"

pattern=$(echo "$ENDUNGEN" | sed 's/ /\\|/g')
if [ ! "$(ls -A *.{$pattern} 2>/dev/null)" ]; then
    echo "No images with the endings ($ENDINGS) found in the current directory!"
    exit 1
fi
folder_count=1
mapfile -t images < <(ls -1 *.{$pattern} 2>/dev/null | sort)
total_images=${#images[@]}
if [ $total_images -eq 0 ]; then
    echo "No images found for processing!"
    exit 1
fi
for ((i=0; i<total_images; i+=ANZAHL)); do
    folder_name=$(printf "folder_%02d" $folder_count)
    mkdir -p "$folder_name"
    for ((j=i; j<i+ANZAHL && j<total_images; j++)); do
        mv "${images[j]}" "$folder_name/"
    done
    echo "Move images $((i+1)) to $((i+number < total_images ? i+number : total_images)) to $folder_name"
    ((folder_count++))
done
echo "Done! $total_images images have been distributed to $((folder_count-1)) folder."
