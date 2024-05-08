service apache2 stop

mkdir /var/www/jarkom/worker2
cp -r dir-listing/worker2/* /var/www/jarkom/worker2

service php7.0-fpm start

mkdir /var/www/jarkom

cp ./lb/worker/index.php /var/www/jarkom/index.php

rm /etc/nginx/sites-enabled/defaultnginx

cp defaultnginxworker2 /etc/nginx/sites-available/defaultnginxworker2
ln -s /etc/nginx/sites-available/defaultnginxworker2 /etc/nginx/sites-enabled/defaultnginxworker2

service nginx restart

nginx -t