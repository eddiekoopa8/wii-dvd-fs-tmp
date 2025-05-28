#!/bin/bash

# Global variables
baselnk="https://myrient.erista.me/files/Redump/Nintendo%20-%20Wii%20-%20NKit%20RVZ%20[zstd-19-128k]"

start=0
count=5000

index=0

fileext=".a"

start=$(( start - 1 ))
count=$(( count + start ))
count=$(( count + 1 ))
fileextCheck="${fileext} "
while read line; do
    if (( index > start )); then
        if (( index < count )); then
            if test -f "list/$line.txt"; then
				
				while read fileraw; do
					if [[ $fileraw == *"$fileextCheck"* ]]; then
						gamelnk="$baselnk/$line.zip"
						gamezip="$line.zip"
						gamedisc="$line.rvz"
						if ! test -f "$gamedisc"; then
							echo -e "$line"
							echo -e "     Download"
							wget -q "$gamelnk"
							while [ $? -eq 4 ]; do
								echo -e "         TRY AGAIN"
								wget -q "$gamelnk"
							done
							echo -e "         ERROR code $?"
							echo -e "     Extract"
							7z x "$gamezip" -y -bso0 -bsp0 -bse0
							rm -rf "$gamezip"
						fi
						exclude=" | "
						fileName="${fileraw#*$exclude*}"
						exclude="${fileName#*$fileext*}"
						fileName=${fileName//"$exclude"/}
						
						# echo -e "$fileraw"
						#echo -e "$line - \"$fileName\""
						mkdir -p "$line/${fileName%/*}"
						#echo -e "$line - \"${fileName%/*}\""
						./dtk vfs cp "${gamedisc}:files/$fileName" "$line/$fileName"
					fi
				done <"list/$line.txt"
				rm -rf "$gamedisc"
            fi
        fi
    fi
    index=$(( index + 1 ))
done <list.txt
