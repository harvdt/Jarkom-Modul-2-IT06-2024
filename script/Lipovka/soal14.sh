service apache2 stop

apt install php-fpm -y

service php7.0-fpm start

mkdir /var/www/jarkom

cp ./lb/worker/index.php /var/www/jarkom/index.php

rm /etc/nginx/sites-enabled/default

cp defaultnginx /etc/nginx/sites-available/defaultnginx
ln -s /etc/nginx/sites-available/defaultnginx /etc/nginx/sites-enabled/defaultnginx

service nginx restart

nginx -t