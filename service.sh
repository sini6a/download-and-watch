#!/bin/bash
# GLOBAL VARIABLES
# DO NOT EDIT!!
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

WATCH_DIR="$HOME/Developer/test"
# Change it to Video
MOVIES_PATH="$HOME/Videos"
# Change it to Video/Downloaded
SCREEN_NAME="torrent-stream"

clear
echo -e "\e[32mWatching directory: \e[31m$WATCH_DIR \e[0m"
echo -e "\e[32mSave directory: \e[31m$MOVIES_PATH \e[0m"
echo

/bin/inotifywait -m $WATCH_DIR -e create -e moved_to |
    while read path action file; do
		echo
        if [[ "$file" =~ .*torrent$ ]]; then
            echo -e "\e[32mTorrent: \e[31m$file\e[0m"
            echo -e "\e[32mDownloading in screen: \e[31m$SCREEN_NAME\e[0m"
            /bin/screen -dmS "$SCREEN_NAME" webtorrent "$WATCH_DIR/$file" --out "$MOVIES_PATH" 
            
            echo
            echo -e "\e[32mWaiting 15s before downloading subtitle...\e[0m" && sleep 15s
            echo -e "\e[32mDownloading subtitle...\e[0m"
            MOVIE_FOLDER=$(echo "${file%.*}")
            MOVIE_FILE=$(find "$MOVIES_PATH/$MOVIE_FOLDER/" -name '*.mp4')
            /bin/python "$SCRIPTPATH/subtitles.py" -a --cli -o "$MOVIES_PATH/$MOVIE_FOLDER/" "$MOVIE_FILE"
            
            echo
            echo -e "\e[32mSubtitles should be downloaded, please check log above.\e[0m"
            echo -e "\e[32mNow playing with \e[31mmplayer\e[0m \e[32mon default screen.\e[0m"
            
            echo
            echo -e "\e[32mAvailable screens: \e[0m"
            while [ $(/bin/screen -list | /bin/wc -l) -gt 2 ]; do
				tput sc
				
				/bin/screen -list
				sleep 1s
				
				tput rc
				tput ed
				
			done
			
			clear
			echo -e "\e[32mWatching directory: \e[31m$WATCH_DIR \e[0m"
			echo -e "\e[32mSave directory: \e[31m$MOVIES_PATH \e[0m"
			echo
            
        else
			echo -e "\e[31mERROR: Not a torrent file!\e[0m"
        fi
    done
