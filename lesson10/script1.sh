
#!/bin/bash

myfolder="$HOME/myfolder"

mkdir -p "$myfolder"

echo "Hello, Gay" > "$myfolder/file1"
date >> "$myfolder/file1"

: > "$myfolder/file2"
chmod 777 "$myfolder/file2"

random_string=$(od -An -N10 -tx1 /dev/urandom | tr -d '[:space:]')
printf '%s\n' "$random_string" > "$myfolder/file3"

: > "$myfolder/file4"
: > "$myfolder/file5"
