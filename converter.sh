#!/bin/bash

set -e # Breaks the program execution on error

target=$( find -name *.$1 | wc -l )
completed=0

function convert_videos {
    for file in *; do
        filename=${file%%.*}
        extension=${file##*.}
        if [ $extension = "$1" ]; then
            original=$file
            converted="${filename}.$2"
            ffmpeg -i "$original" "$converted" 2>> /dev/null 
            mv "$converted" ../Converted/
            let completed++
            echo $((100*$completed/$target))% complete
        fi
    done;
}

convert_videos # Calling the function to execute it.

if [ $# -eq 3 ]; then # Test format fix
   pushd "$3"
fi

echo "Total files to convert: $target"
[[ -e "Converted" ]] && printf "\nDirectory Converted already exists\n\n" || mkdir Converted # Test for the folder to avoid error message.
mkdir Converted
for d in */; do
    pushd "$d"
    echo "converting files in $d"
    convert_videos "$@"
    popd
    echo "Files converted: $( find -name *.$2 | wc -l )"
done;

if [ $# -eq 3 ]; then # Test format fix
  popd
fi

echo "Done. Total files converted: $( find -name *.$2 | wc -l )"
