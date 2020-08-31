# Nodejs-Guide
Nodejs App Hosting on any Debian Distributions 

Copy the Files to same location as of your NodeJS app folder.

For Hosting Nodejs App run hostjs.sh as administrator user and name of app (app.js/index.js/server.js etc or path to them)

Executable permission to script

chmod +x hostjs.sh


Examples - 

./hostjs.sh /path_to_app/app.js

./host.sh app.js

Then Select option 1 to host the site and AutoStart the application in case of any failure in app or system reboots.

Now visit        your_ip:port and verify that site is working.

For other operations other than hosting there is no need of any parameter.

Note – Please note the port number on which NodeJS application is running

Now we will use the Nginx as a reverse proxy to Nodejs App Running at our localhost

For that we need the port number on which Nodejs app is running

Open the nginx file I have included with any text editor and change the “port_number” to your Nodejs app port number

Then again run the script and choose option to select Use Nginx proxy

Done.

Now visit http://your_ip/

Optional Steps-

If you have domain use certbot to generate SSL certificate for you and configure it with nginx

Now your site is hosted and secures with SSL
