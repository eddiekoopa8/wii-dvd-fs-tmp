#!/bin/bash
echo SETUP!!!

# Global variables
baselnk="https://myrient.erista.me/files/Redump/Nintendo%20-%20Wii%20-%20NKit%20RVZ%20[zstd-19-128k]"

# Get DTK
rm -rf dtk
wget -q "https://github.com/encounter/decomp-toolkit/releases/download/v1.5.1/dtk-linux-x86_64"
mv dtk* dtk
chmod +x dtk

mkdir -p list


declare -i start=0
declare -i count=10

declare -i index=0

count=$(( count + start ))
count=$(( count + 1 ))

# Processing
while read line; do
	if (( index > start )); then
		if (( index < count )); then
			if ! test -f "list/$line.txt"; then
				gamelnk="$baselnk/$line.zip"
				gamezip="$line.zip"
				gamedisc="$line.rvz"
				echo -e "Processing $line"
				wget -q "$gamelnk"
				7z x "$gamezip" -y -bso0 -bsp0 -bse0
				rm -rf "$gamezip"
				./dtk vfs ls -r "$gamedisc:files" > "list/$line.txt"
				rm -rf "$gamedisc"
			fi
		fi
	fi
	index=$(( index + 1 ))
done <list.txt

