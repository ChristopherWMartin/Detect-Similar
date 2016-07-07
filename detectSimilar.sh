#!/bin/bash

command -v convert >/dev/null 2>&1 || { echo "This script requires 'ImageMagick'. Aborting." >&2; exit 1; }
command -v bc >/dev/null 2>&1 || { echo "This script requires 'bc'. Aborting." >&2; exit 1; }

bold=$(tput bold)
normal=$(tput sgr0)

definedThreshhold=0.2

for i in $(ls -R |grep .jpg$); do
	  for j in $(ls -R |grep .jpg$); do
        if [[ -f $i ]] && [[ -f $j ]] && [[ "$i" != "$j" ]] ;
        then
            convert $i $j -compose difference -composite \
			              -colorspace Gray difference.jpeg

            read width height < <(identify -format '%w %h' difference.jpeg)
            totalPixels=$((width * height))
            acceptableThreshhold=$(echo "scale=0; ($definedThreshhold * $totalPixels)/1" | bc)

            read white < <(convert difference.jpeg -format "%[fx:mean*w*h]" info:)
            white=$(echo "scale=0; $white/1" | bc)

            difference=$(echo "scale=2; ($white / $totalPixels)*100" | bc)

            if (("$white" < "$acceptableThreshhold")) ;
            then
                echo "${bold}removing $j -- too similar to $i${normal}"
                mv $j delete-$j.jpeg
            fi
            echo "$i & $j - Difference: $difference%"
        fi
    done
done

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ls $DIR/*.jpeg | cat -n
#rm $DIR/*.jpeg
