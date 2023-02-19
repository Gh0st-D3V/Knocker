#!/bin/bash


#Knocker
#Author: gh0st
#Creation Date: 2/3/2023
#Version: 0.6.dev
#only runs on addresses in honeypots file

#checks if user id is not = to 0
if [ "$EUID" -ne 0 ]
  then echo "You are not Root!"
  exit
fi


clear
echo "Welcome to Knocker, do you want to play ding dong ditch?"
echo "Please select one of the following..."
echo "1: knock on ftp"
echo "2: knock on ssh"
echo "3: knock on rdp"
echo "4: knock on user supplied port"
echo "5: Run G.O.O.S.E"
echo "0: Quit"
echo ""
echo -n  "Input: "; read mainmenu

#ftp masscan
if  [ "$mainmenu" = "1" ]
        then
        echo "Ding!"
        sudo masscan -iL HoneyPots.txt -p 21 --open -Pn -oG - | awk '/open/{print $4}' > knocker.log
        echo "Dong!"
	sleep 2
        exec "$0"
#ssh masscan
elif [ "$mainmenu" = "2" ]
        then
                echo "Ding!"
                sudo masscan -iL HoneyPots.txt -p 22 --open  -Pn -oG - | awk '/open/{print $4}' > knocker.log
                echo "Dong!"
        	sleep 2
		exec "$0"
#rdp masscan
elif [ "$mainmenu" = "3" ]
        then
                echo "Ding!"
                sudo  masscan -iL HoneyPots.txt -p 3389 --open -Pn -oG - | awk '/open/{print $4}' > knocker.log
                echo "Dong!"
		sleep 2
		exec "$0"
#user supplied port masscan
elif [ "$mainmenu" = "4" ]
        then
                echo -n  "Please enter a port number: "; read portnumber
                echo "Ding!"
                sudo masscan -iL HoneyPots.txt -p "$portnumber" --open -Pn -oG - | awk '/open/{print $4}' > knocker.log
                echo "Dong!"
		sleep 2
		exec "$0"
#runs GOOSE python script
elif [ "$mainmenu" = "5" ]
	then
		python3 GOOSE.py <<< knocker.log
		clear
		cat Usernames.csv
#exits
elif [ "$mainmenu" = "0" ]
        then
                echo "Good Bye!"
                sleep 2
		clear
                exit
       #user error
	 else
                echo "That wasnt an option"
                sleep 3
                exec "$0"
fi

