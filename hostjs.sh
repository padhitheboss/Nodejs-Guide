#!/bin/bash
echo "Installing Nodejs and npm"
sudo apt install nodejs && sudo apt install npm
User=$USER
App_Path=$1

#installing required node files from repo and making it a process
function hostjs(){
    sudo npm install
    sudo npm install pm2@latest -g
    echo "Enter A name for this app"
    read App_Name
    pm2 start $App_Path --name "$App_Name"
    sudo pm2 startup systemd
    sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $User --hp $HOME
    pm2 save
    sudo systemctl start pm2-$User
    sudo systemctl enable pm2-$User
    echo "Make Sure That you have changed port in nginx file included"
    echo -n "Do you want to configure nginx with it (Y|N): "
    read choice
    if [[ $choice == 'Y' ]] 
    then
        setnginx
    fi
}

function setnginx(){
    echo -n "Have you changed port on nginx file included with this script (Y|N): "
    read choice
    if [[ $choice == 'Y' ]] 
    then
        sudo apt install nginx
        sudo systemctl enable nginx
        sudo rm /etc/nginx/sites-enabled/default
        sudo cp nginx /etc/nginx/sites-available/$App_Name
        sudo ln -s /etc/nginx/sites-available/$App_Name /etc/nginx/sites-enabled/$App_Name
        sudo service nginx restart
    fi
}

function apps(){
    clear
    pm2 list
}

function stopapp(){
    apps
    echo -n "Enter the name of app you want to stop"
    read name
    pm2 stop $name
}

function restartapp(){
    apps
    echo -n "Enter the name of app you want to restart :"
    read name
    pm2 restart $name
}

function showlogs(){
    apps
    echo -n "Enter the name of app you want to view logs :"
    read name
    cat $HOME/.pm2/logs/$name-out.log
    echo -n "Do you want to clear logs(Y|N)"
    read option
    if [[ $option == 'Y' ]] 
    then
        rm $HOME/.pm2/logs/$name-out.log
        touch $HOME/.pm2/logs/$name-out.log
    fi
}

function delapp(){
    apps
    echo -n "Enter the name of app you want to delete from autostart :"
    read name
    pm2 delete $name
}

function mainmenu(){
    clear
    echo " "
    echo "Backup Database"
    echo " "
    echo "Choose a option from below:"
         echo "1. Host A Nodejs App"
         echo "2. Show Running Apps"
         echo "3. Stop a Running App"
         echo "4. Restart a Running App"
         echo "5. Show Logs of a App"
         echo "6. Delete App From Autostart list"
         echo "7. Configure Nginx to work with the Nodejs App"
         echo "8. Exit"
    echo " "
    echo -n "Enter Option No.:"
    read option
    case $option in
        1)
            hostjs
            read -n 1 -p "<Enter> for main menu"
            mainmenu
        ;;

        2)
            apps
            read -n 1 -p "<Enter> for main menu"
            mainmenu
        ;;

        3)
            stopapp
            read -n 1 -p "<Enter> for main menu"
            mainmenu
        ;;

        4)
            restartapp
            read -n 1 -p "<Enter> for main menu"
            mainmenu
        ;;

        5)
            showlogs
            read -n 1 -p "<Enter> for main menu"
            mainmenu
        ;;
          
        6)
            delapp
            read -n 1 -p "<Enter> for main menu"
            mainmenu
        ;;

        7)
            setnginx
            read -n 1 -p "<Enter> for main menu"
            mainmenu
        ;;       
        
        
        8)
                function goout () {
                        TIME=1
                        echo " "
                        echo "Leaving the system ......"
                        sleep $TIME
                        exit 0
                }
                goout
        ;;

esac
}
mainmenu
