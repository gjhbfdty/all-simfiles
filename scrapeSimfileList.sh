#!/bin/bash
base_url="https://zenius-i-vanisher.com/v5.2/viewsimfile.php?simfileid="

for ((simfileid=1; simfileid<=60327; simfileid++)); do
    url="${base_url}${simfileid}"

    html_content=$(curl -s "$url")

    # Extract content within <h1> tag
    header=$(echo "$html_content" | grep -o '<h1>[^<]*</h1>' | sed 's/<[^>]*>//g')

    echo "$header --- $simfileid" >> allsimfiles.txt
done

# filter out Errors or empty results (deleted files?)
cat allsimfiles.txt | grep -vE '^(Error\s*---\s*| --- )'  | tee filteredAllsimfiles.txt

# replace special characters
sed -i "s/\&amp\;/\&/g" filteredAllsimfiles.txt
sed -i "s/\&quot\;/\"/g" filteredAllsimfiles.txt
sed -i "s/\&gt\;/\>/g" filteredAllsimfiles.txt
sed -i "s/\&lt\;/\</g" filteredAllsimfiles.txt

# create lists sorted by artist and song
awk -F ' / | ---'  '{printf "%s / %s ---%s\n", $2, $1, $3}' filteredAllsimfiles.txt  | sort -f | tee sortedByArtist.txt
awk -F ' / | ---'  '{printf "%s / %s ---%s\n", $1, $2, $3}' filteredAllsimfiles.txt  | sort -f | tee sortedBySong.txt