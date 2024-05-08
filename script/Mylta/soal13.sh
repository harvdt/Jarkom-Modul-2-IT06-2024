a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests

cp loadBalance.conf /etc/apache2/sites-available/loadBalance.conf
rm 000-default.conf

a2ensite loadBalance.conf

service apache2 restart