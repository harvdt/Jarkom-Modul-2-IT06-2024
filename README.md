Laporan-Jarkom-Modul-2-IT06-2024

| Nama | NRP |
| ----------- | ----------- |
| Sylvia Febrianti | 5027221019 |
| Muhammad Harvian Dito Syahputra | 5027221039 |


## Soal 11

Setelah pertempuran mereda, warga Erangel dapat kembali mengakses jaringan luar, tetapi hanya warga Pochinki saja yang dapat mengakses jaringan luar secara langsung. Buatlah konfigurasi agar warga Erangel yang berada diluar Pochinki dapat mengakses jaringan luar melalui DNS Server Pochinki

### Pochinki 
Membuat konfigurasi forward DNS terlebih dahulu yang disimpan pada file forwardDNS.txt

```
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1; // IP Erangel
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
```

Kemudian dibuat script untuk mengaktifkan konfigurasi forward DNS

```
cp forwardDNS.txt /etc/bind/named.conf.options

service bind9 restart

echo "Configuration Complete"
```

### Testing 
Menjalankan ping dengan IP Pochinki di /etc/resolv.conf.
// ss testing

## Soal 12

Karena pusat ingin sebuah website yang ingin digunakan untuk memantau kondisi markas lainnya maka deploy lah webiste ini (cek resource yg lb) pada severny menggunakan apache

### Severny
Membuat konfigurasi apache terlebih dahulu di dalam default.conf
```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
Kemudian dibuat script untuk melakukan download resource melalui google drive yang telah disediakan. Setelah itu, mengaktifkan konfigurasi yang telah dibuat

```
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=11S6CzcvLG-dB0ws1yp494IURnDvtIOcq' -O 'dir-listing.zip'
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121HnfB' -O 'lb.zip'

unzip -o dir-listing.zip -d dir-listing
unzip -o lb.zip -d lb

cp default.conf /etc/apache2/sites-available/default.conf
rm /etc/apache2/sites-available/000-default.conf

cp ./lb/worker/index.php /var/www/html/index.php

a2ensite default.conf

service apache2 restart
```

### Testing
Melakukan lynx http://192.236.4.2/index.php (IP severny)
// ss testing

## Soal 13

Tapi pusat merasa tidak puas dengan performanya karena traffic yag tinggi maka pusat meminta kita memasang load balancer pada web nya, dengan Severny, Stalber, Lipovka sebagai worker dan Mylta sebagai Load Balancer menggunakan apache sebagai web server nya dan load balancernya

### Stalber dan Lipovka
Melakukan hal yang sama dengan yang dilakukan pada node Severny

### Mylta
Membuat konfigurasi Load Balancer menggunakan apache yang disimpan pada loadBalancer.conf
```
<VirtualHost *:80>
    <Proxy balancer://mycluster>
      BalancerMember http://192.236.4.2:80
      BalancerMember http://192.235.4.3:80
      BalancerMember http://192.235.4.4:80
    </Proxy>
    ProxyPreserveHost On
    ProxyPass / balancer://mycluster/
    ProxyPassReverse / balancer://mycluster/
</VirtualHost>
```

Kemudian dilakukan pengaktifan konfigurasi Load Balancer tersebut dengen menggunakan script sebagai berikut
```
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer

cp loadBalance.conf /etc/apache2/sites-available/loadBalance.conf
rm 000-default.conf

a2ensite loadBalance.conf

service apache2 restart
```

### Testing
Melakukan lynx ke masing-masing IP
lynx 192.236.4.3/index.php (IP Stalber)
lynx 192.236.4.4/index.php (IP Lipovka)

// ss testing stalber
// ss testing lipovka

## Soal 14

Mereka juga belum merasa puas jadi pusat meminta agar web servernya dan load balancer nya diubah menjadi nginx

### Severny, Stalber, dan Lipovka
Dilakukan pembuatan konfigurasi worker menggunakan nginx pada ketiga worker tersebut yang disimpan pada file defaultnginx
```
server {
    listen 80;
    root /var/www/jarkom;
    index index.php index.html index.htm;
    server_name tamat.it06.com www.tamat.it06.com;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location /worker2 {
        index index.html;
        autoindex on;
        autoindex_exact_size off;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }

    error_log /var/log/nginx/jarkom_error.log;
    access_log /var/log/nginx/jarkom_access.log;
}
```

Kemudian dilakukan pengaktifan konfigurasi tersebut dengan script berikut
```
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
```

### Mylta
Dilakukan pembuatan script Load Balancer dengan menggunakan nginx yang disimpan pada file lb-jarkom
```
upstream myweb  {
        server 192.236.4.2; #IP Severny
        server 192.236.4.3; #IP Stalber
        server 192.236.4.4; #IP Lipovka
}

server {
        listen 80;
        server_name mylta.it06.com www.mylta.it06.com;

        location / {
          proxy_pass http://myweb;
        }
}
```

Kemudian dilakukan pengaktifan konfigurasi yang sudah dibuat dengan menggunakan scirpt berikut
```
service apache2 stop

service nginx start

rm /etc/nginx/sites-enabled/default
cp lb-jarkom /etc/nginx/sites-available/lb-jarkom

ln -s /etc/nginx/sites-available/lb-jarkom /etc/nginx/sites-enabled/lb-jarkom

service nginx restart
```

### Testing
Dilakukan lynx terhadap masing-masing IP
lynx 192.236.4.2 (IP Severny)
lynx 192.236.4.3 (IP Stalber)
lynx 192.236.4.4 (IP Lipovka)
lynx 192.236.4.5 (IP Mylta)

// ss masing-masing testing

## Soal 15

Markas pusat meminta laporan hasil benchmark dengan menggunakan apache benchmark dari load balancer dengan 2 web server yang berbeda tersebut dan meminta secara detail dengan ketentuan:
- Nama Algoritma Load Balancer
- Report hasil testing apache benchmark 
- Grafik request per second untuk masing masing algoritma. 
- Analisis

###  Testing
Menjalankan apache benchmark dengan menggunakan 2 web server yang berda. Didapatkan hasil seperti berikut
// hasil analisis

## Soal 16

Karena dirasa kurang aman karena masih memakai IP, markas ingin akses ke mylta memakai mylta.xxx.com dengan alias www.mylta.xxx.com (sesuai web server terbaik hasil analisis kalian)

### Pochinki
Membuat konfigurasi agar dapat mengaktifkan mylta.it06.com dan www.mylta.it06.com
```
echo 'zone "mylta.it06.com" {
    type master;
    file "/etc/bind/jarkom/mylta.it06.com";
};' >> /etc/bind/named.conf.local

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mylta.it06.com. root.mylta.it06.com. (
                                2         ; Serial
                                604800    ; Refresh
                                86400     ; Retry
                                2419200   ; Expire
                                604800 )  ; Negative Cache TTL
;
@       IN      NS      mylta.it06.com.
@       IN      A       192.236.4.5       ; IP Mylta
www     IN      CNAME   mylta.it06.com.' > /etc/bind/jarkom/mylta.it06.com

service bind9 restart
```

### Testing
Melakukan ping terhadap mylta.it06.com dan www.mylta.it06.com serta melakukan lynx mylta.it06.com dan lynx mylta.it06.com

// Hasil testing

## Soal 17

Agar aman, buatlah konfigurasi agar mylta.xxx.com hanya dapat diakses melalui port 14000 dan 14400.

### Mylta 
Membuat konfigurasi baru untuk hanya menerima akses melalui port 14000 dan 14400 yang disimpan pada file lb-jarkom-port
```
upstream myweb  {
        server 192.236.4.2:80; #IP Severny
        server 192.236.4.3:80; #IP Stalber
        server 192.236.4.4:80; #IP Lipovka
}

server {
        listen 14000;
        server_name mylta.it06.com www.mylta.it06.com;

        location / {
          proxy_pass http://myweb;
        }
}

server {
        listen 14400;
        server_name mylta.it06.com www.mylta.it06.com;

        location / {
          proxy_pass http://myweb;
        }
}

server {
    listen 80;
    server_name mylta.it06.com www.mylta.it06.com;

    return 404;
}
```

Kemudian dilakukan pengaktifan konfigurasi baru melalui script berikut
```
service apache2 stop

rm /etc/nginx/sites-enabled/lb-jarkom
cp lb-jarkom-port /etc/nginx/sites-available/lb-jarkom-port

ln -s /etc/nginx/sites-available/lb-jarkom-port /etc/nginx/sites-enabled/lb-jarkom-port

service nginx restart
```

### Testing
Dilakukan akses ke masing-masing port dengan lynx mylta.it06.com:14000 dan lynx mylta.it06.com:14400

// Hasil testing

## Soal 18

Apa bila ada yang mencoba mengakses IP mylta akan secara otomatis dialihkan ke www.mylta.xxx.com

### Pochinki

Dilakukan pembuatan konfigurasi untuk mengalihkan akses IP Mylta ke www.mylta.it06.com
```
echo 'zone "4.236.192.in-addr.arpa.mylta" {
    type master;
    file "/etc/bind/jarkom/4.236.192.in-addr.arpa.mylta";
};' >> /etc/bind/named.conf.local

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     mylta.it06.com. root.mylta.it06.com. (
                                2         ; Serial
                                604800    ; Refresh
                                86400     ; Retry
                                2419200   ; Expire
                                604800 )  ; Negative Cache TTL
;
4.236.192.in-addr-arpa          IN      NS      mylta.it06.com.
2                               IN      PTR     mylta.it06.com.' > /etc/bind/jarkom/4.236.192.in-addr-arpa.mylta

service bind9 restart

ech0 'Configuration Complete'
```

### Testing

Dilakukan akses langsung dengan menggunakan IP

// hasil testing

## Soal 19

Karena probset sudah kehabisan ide masuk ke salah satu worker buatkan akses direktori listing yang mengarah ke resource worker2

### Severny
Dilakukan di salah satu worker, worker yang dipilih yaitu Severny. Dibuat konfigurasi baru untuk mengaktifkan directory listing dengan mengarah ke resource worker2 yang telah disediakan. Konfigurasi disimpan pada defaultnginxworker2
```
server {
    listen 80;
    root /var/www/jarkom;
    index index.php index.html index.htm;
    server_name tamat.it06.com www.tamat.it06.com;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location /worker2 {
        index index.html;
        autoindex on;
        autoindex_exact_size off;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }

    error_log /var/log/nginx/jarkom_error.log;
    access_log /var/log/nginx/jarkom_access.log;
}
```

Dilakukan pengaktifan konfigurasi baru dengan menggunakan script sebagi berikut
```
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
```

### Testing
Dilakukan lynx 192.236.4.2/worker2 (IP Severny yang mengarah ke directory worker2)

// ss hasil testing

## Soal 20

Worker tersebut harus dapat di akses dengan tamat.xxx.com dengan alias www.tamat.xxx.com

### Pochinki
Dibuat konfigurasi baru untuk mengaktifkan tamat.it06.com dan www.tamat.it06.com
```
echo 'zone "tamat.it06.com" {
    type master;
    file "/etc/bind/jarkom/tamat.it06.com";
};' >> /etc/bind/named.conf.local

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     tamat.it06.com. root.tamat.it06.com. (
                                2         ; Serial
                                604800    ; Refresh
                                86400     ; Retry
                                2419200   ; Expire
                                604800 )  ; Negative Cache TTL
;
@       IN      NS      tamat.it06.com.
@       IN      A       192.236.4.2       ; IP Severny
www     IN      CNAME   tamat.it06.com.' > /etc/bind/jarkom/tamat.it06.com

service bind9 restart

echo 'Configuration Complete'
```

### Testing
Dilakukan lynx mylta.it06.com/worker2 dan lynx www.mylta.it06.com/worker2

// hasil testing
