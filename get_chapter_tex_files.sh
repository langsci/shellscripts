#!/bin/bash

mkdir -p store
for i in {16..350}; do
    echo -n 0 > flag
    echo "retrieving $i"
    if [ -d "store/$i" ]; then
        echo " $i already present"
        continue
    fi
    if [ -d "$i" ]; then
        echo " $i already present as a repository, but not in store. Please resolve this manually"
        continue
    else
        echo " cloning git@github.com:langsci/$i.git"
#         clone the repo. If this fails, make a dummy dir and store the information there
        git clone --quiet git@github.com:langsci/$i.git 2> /dev/null || ( mkdir $i && touch $i/nonexistingrepo && echo "  repo could not be cloned" && echo 1 > flag)
        flag=$(cat flag)
        if ((flag == 1 )); then continue; fi
        if [ -d "$i/chapters" ]; then
            mv $i/chapters store/$i
            rm -rf $i
        else
            echo "  $i has no folder chapters/. Please retrieve tex files manually"
        fi
    fi
done
