#!/bin/bash

myfolder="$HOME/myfolder"

if [[ ! -d "$myfolder" ]]; then
    echo "Директория не существует"
    exit 0
fi

count=$(find "$myfolder" -maxdepth 1 -type f | wc -l)
echo "Количество файлов: $count"

if [[ -f "$myfolder/file2" ]]; then
    chmod 664 "$myfolder/file2"
fi

for file in "$myfolder"/*; do
    if [[ ! -f "$file" ]]; then
        continue
    fi

    if [[ ! -s "$file" ]]; then
        rm -- "$file"
    else
        sed -i '2,$d' "$file"
    fi
done
