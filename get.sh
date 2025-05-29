#!/bin/bash

# Global variables
baselnk="https://myrient.erista.me/files/Redump/Nintendo%20-%20Wii%20-%20NKit%20RVZ%20[zstd-19-128k]"

start=2800
count=100

index=0

start=$(( start - 1 ))
count=$(( count + start ))
count=$(( count + 1 ))
while read line; do
    if (( index > start )); then
        if (( index < count )); then
            if ! test -f "list/$line.txt"; then
                gamelnk="$baselnk/$line.zip"
                gamezip="$line.zip"
		attempt=0
                #gamedisc="$line.rvz"
                echo -e "$line ($index/$count done)"
                echo -e "     Download"
                wget -q "$gamelnk"
                while [ $? -eq 4 ]; do
                    echo -e "         TRY AGAIN"
                    wget -q --read-timeout=1500 "$gamelnk"
		    if (( attempt > 2 )); then
                        break
                    fi
		    attempt=$(( attempt + 1 ))
                done
                echo -e "         ERROR code $?"
                echo -e "     Extract"
                7z x "$gamezip" -y -bso0 -bsp0 -bse0
                rm -rf "$gamezip"
                rvzlist=(*.rvz)
                gamedisc="${rvzlist[0]}"
                echo -e "     List"
                ./dtk vfs ls -r "$gamedisc:files" > "list/$line.txt"
                rm -rf "$gamedisc"
            fi
        fi
    fi
    index=$(( index + 1 ))
done <list.txt
echo -e "All $count completed!"
