service apache2 stop

rm /etc/nginx/sites-enabled/lb-jarkom
cp lb-jarkom-port /etc/nginx/sites-available/lb-jarkom-port

ln -s /etc/nginx/sites-available/lb-jarkom-port /etc/nginx/sites-enabled/lb-jarkom-port

service nginx restart
