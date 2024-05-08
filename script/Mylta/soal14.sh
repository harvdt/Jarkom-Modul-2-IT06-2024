service apache2 stop

service nginx start

rm /etc/nginx/sites-enabled/default
cp lb-jarkom /etc/nginx/sites-available/lb-jarkom

ln -s /etc/nginx/sites-available/lb-jarkom /etc/nginx/sites-enabled/lb-jarkom

service nginx restart