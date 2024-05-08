# Laporan-Jarkom-Modul-2-IT06-2024
Praktikum Jaringan Komputer Modul 2 Tahun 2024

## Anggota
| Nama | NRP |
| ----------- | ----------- |
| Sylvia Febrianti | 5027221019 |
| Muhammad Harvian Dito Syahputra | 5027221039 |

# Laporan Resmi
## Topologi
![topologi](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/topologi.png)

## Soal 1
Untuk membantu pertempuran di Erangel, kamu ditugaskan untuk membuat jaringan komputer yang akan digunakan sebagai alat komunikasi. Sesuaikan rancangan Topologi dengan rancangan dan pembagian yang berada di link yang telah disediakan, dengan ketentuan nodenya sebagai berikut :
- DNS Master akan diberi nama Pochinki, sesuai dengan kota tempat dibuatnya server tersebut
- Karena ada kemungkinan musuh akan mencoba menyerang Server Utama, maka buatlah DNS Slave Georgopol yang mengarah ke Pochinki
- Markas pusat juga meminta dibuatkan tiga Web Server yaitu Severny, Stalber, dan Lipovka. Sedangkan Mylta akan bertindak sebagai Load Balancer untuk server-server tersebut

## Node Configuration
### Erangel
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.236.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.236.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.236.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.236.4.1
	netmask 255.255.255.0
```

### Pochinki 
```
auto eth0
iface eth0 inet static
	address 192.236.1.2
	netmask 255.255.255.0
	gateway 192.236.1.1
```

### Georgopol
```
auto eth0
iface eth0 inet static
	address 192.236.3.2
	netmask 255.255.255.0
	gateway 192.236.3.1
```

### Gatka
```
auto eth0
iface eth0 inet static
	address 192.236.3.3
	netmask 255.255.255.0
	gateway 192.236.3.1
```

### Quarry
```
auto eth0
iface eth0 inet static
	address 192.236.2.2
	netmask 255.255.255.0
	gateway 192.236.2.1
```

### Shelter
```
auto eth0
iface eth0 inet static
	address 192.236.2.3
	netmask 255.255.255.0
	gateway 192.236.2.1
```

### Serverny
```
auto eth0
iface eth0 inet static
	address 192.236.4.2
	netmask 255.255.255.0
	gateway 192.236.4.1
```

### Stalber
```
auto eth0
iface eth0 inet static
	address 192.236.4.3
	netmask 255.255.255.0
	gateway 192.236.4.1
```

### Lipovka
```
auto eth0
iface eth0 inet static
	address 192.236.4.4
	netmask 255.255.255.0
	gateway 192.236.4.1
```

### Mylta
```
auto eth0
iface eth0 inet static
	address 192.236.4.5
	netmask 255.255.255.0
	gateway 192.236.4.1
```

## Install & Setup
### Erangel
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.236.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

### DNS Master & Slave (Pocinki & Georgopol)
```
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install bind9 -y
```

### gatka, quarry, shelte
```
echo '
nameserver 192.236.1.2 # IP Pochinki
nameserver 192.236.3.2 # IP Georgopol
nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install dnsutils -y
apt-get install lynx -y
```

### Testing
```
ping google.com -c 3
```

### Result
![soal1](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/1.png)

## Soal 2
Karena para pasukan membutuhkan koordinasi untuk mengambil airdrop, maka buatlah sebuah domain yang mengarah ke Stalber dengan alamat airdrop.xxxx.com dengan alias www.airdrop.xxxx.com dimana xxxx merupakan kode kelompok. Contoh : airdrop.it01.com

### Script Solution
```
echo 'zone "airdrop.it06.com" {
        type master;
        file "/etc/bind/jarkom/airdrop.it06.com";
};' >> /etc/bind/named.conf.local

# Create directory for zone file
mkdir -p /etc/bind/jarkom

# Copy db.local to the specified directory
cp /etc/bind/db.local /etc/bind/jarkom/airdrop.it06.com

# Create zone file
cat << EOF > /etc/bind/jarkom/airdrop.it06.com
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     airdrop.it06.com. root.airdrop.it06.com. (
                        2024030501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      airdrop.it06.com.
@       IN      A       192.236.4.3     ; Stalber
www     IN      CNAME   airdrop.it06.com.
EOF

# Restart BIND service
service bind9 restart
```

### Testing
```
ping airdrop.it06.com -c 3
ping www.airdrop.it06.com -c 3
host -t CNAME www.airdrop.it06.com
```

### Result
![soal2](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/2.1.png)
![soal2](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/2.2.png)
![soal2](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/2.3.png)

## Soal 3
Para pasukan juga perlu mengetahui mana titik yang sedang di bombardir artileri, sehingga dibutuhkan domain lain yaitu redzone.xxxx.com dengan alias www.redzone.xxxx.com yang mengarah ke Severny
```
echo 'zone "redzone.it06.com" {
        type master;
        file "/etc/bind/jarkom/redzone.it06.com";
};' >> /etc/bind/named.conf.local

# Copy db.local to the specified directory
cp /etc/bind/db.local /etc/bind/jarkom/redzone.it06.com

# Create zone file
cat << EOF > /etc/bind/jarkom/redzone.it06.com
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     redzone.it06.com. root.redzone.it06.com. (
                        2024030501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      redzone.it06.com.
@       IN      A       192.236.4.2     ; Serverny #no 6
www     IN      CNAME   redzone.it06.com.
EOF

# Restart BIND service
service bind9 restart
```

### Testing
```
ping redzone.it06.com -c 3
ping www.redzone.it06.com -c 3
host -t CNAME www.redzone.it06.com
```

### Result
![soal3](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/3.1.png)
![soal3](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/3.2.png)
![soal3](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/3.3.png)

## Soal 4
Markas pusat meminta dibuatnya domain khusus untuk menaruh informasi persenjataan dan suplai yang tersebar. Informasi persenjataan dan suplai tersebut mengarah ke Mylta dan domain yang ingin digunakan adalah loot.xxxx.com dengan alias www.loot.xxxx.com
```
echo 'zone "loot.it06.com" {
        type master;
        file "/etc/bind/jarkom/loot.it06.com";
};' >> /etc/bind/named.conf.local

# Copy db.local to the specified directory
cp /etc/bind/db.local /etc/bind/jarkom/loot.it06.com

# Create zone file
cat << EOF > /etc/bind/jarkom/loot.it06.com
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     loot.it06.com. root.loot.it06.com. (
                        2024030501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      loot.it06.com.
@       IN      A       192.236.4.5     ; Mylta
www     IN      CNAME   loot.it06.com.
EOF

# Restart BIND service
service bind9 restart
```

### Testing
```
ping loot.it06.com -c 3
ping www.loot.it06.com -c 3
host -t CNAME www.loot.it06.com
```

### Result
![soal4](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/4.1.png)
![soal4](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/4.2.png)
![soal4](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/4.3.png)

## Soal 5
Pastikan domain-domain tersebut dapat diakses oleh seluruh komputer (client) yang berada di Erangel
### Testing (Gatka,Quarry,Shelter)
```
ping -c 3 airdrop.it06.com; ping -c 3 redzone.it06.com; ping -c 3 loot.it06.com
```

### Result
![soal5](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/5.1.png)
![soal5](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/5.2.png)
![soal5](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/5.3.png)

## Soal 6
Beberapa daerah memiliki keterbatasan yang menyebabkan hanya dapat mengakses domain secara langsung melalui alamat IP domain tersebut. Karena daerah tersebut tidak diketahui secara spesifik, pastikan semua komputer (client) dapat mengakses domain redzone.xxxx.com melalui alamat IP Severny (Notes : menggunakan pointer record)
```
echo 'zone "4.236.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/4.236.192.in-addr.arpa";
};' >> /etc/bind/named.conf.local

# Copy db.local to the specified directory
cp /etc/bind/db.local /etc/bind/jarkom/4.236.192.in-addr.arpa

# Create reverse zone file
cat << EOF > /etc/bind/jarkom/4.236.192.in-addr.arpa
;
; BIND reverse data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     redzone.it06.com. root.redzone.it06.com. (
                          2024030501      ; Serial
                          604800         ; Refresh
                           86400         ; Retry
                         2419200         ; Expire
                          604800 )       ; Negative Cache TTL
;
4.236.192.in-addr.arpa.      IN      NS      redzone.it06.com.
2         IN  PTR redzone.it06.com. ; Byte ke-4 Servery
EOF

# Restart BIND service
service bind9 restart
```

### Testing
```
host -t PTR 192.236.4.2
```

### Result
![soal6](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/6.png)

## Soal 7
Akhir-akhir ini seringkali terjadi serangan siber ke DNS Server Utama, sebagai tindakan antisipasi kamu diperintahkan untuk membuat DNS Slave di Georgopol untuk semua domain yang sudah dibuat sebelumnya
### Pochinki
```
# Define the new content
new_content=$(cat <<'EOF'
zone "airdrop.it06.com" {
    type master;
    notify yes;
    also-notify { 192.236.3.2; }; 
    allow-transfer { 192.236.3.2; }; 
    file "/etc/bind/jarkom/airdrop.it06.com";
};

zone "redzone.it06.com" {
    type master;
    notify yes;
    also-notify { 192.236.3.2; }; 
    allow-transfer { 192.236.3.2; }; 
    file "/etc/bind/jarkom/redzone.it06.com";
};

zone "loot.it06.com" {
    type master;
    notify yes;
    also-notify { 192.236.3.2; }; 
    allow-transfer { 192.236.3.2; }; 
    file "/etc/bind/jarkom/loot.it06.com";
};

zone "4.236.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/4.236.192.in-addr.arpa";
};
EOF
)

# Overwrite named.conf.local with the new content
echo "$new_content" > /etc/bind/named.conf.local

# Restart BIND service to apply changes
service bind9 restart
```
Langkah awal adalah menambahkan nofity, also-notify dan allow-transfer agar memberikan izin kepada IP yang dituju

### Georgopol 
```
# Define the new content
new_content=$(cat <<'EOF'
zone "airdrop.it06.com" {
    type slave;
    masters { 192.236.1.2; };
    file "/var/lib/bind/airdrop.it06.com";
};

zone "redzone.it06.com" {
    type slave;
    masters { 192.236.1.2; };
    file "/var/lib/bind/redzone.it06.com";
};

zone "loot.it06.com" {
    type slave;
    masters { 192.236.1.2; };
    file "/var/lib/bind/loot.it06.com";
};
EOF
)

# Overwrite named.conf.local with the new content
echo "$new_content" > /etc/bind/named.conf.local

# Restart BIND service to apply changes
service bind9 restart
```
Membuat type slave pada zone dari domain dan mengubah path file

### Testing
```
ping -c 3 airdrop.it06.com; ping -c 3 redzone.it06.com; ping -c 3 loot.it06.com
```

### Result
![soal7](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/7.png)

## Soal 8
Kamu juga diperintahkan untuk membuat subdomain khusus melacak airdrop berisi peralatan medis dengan subdomain medkit.airdrop.xxxx.com yang mengarah ke Lipovka
```
# Define the new content
new_content=$(cat <<'EOF'
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     airdrop.it06.com. root.airdrop.it06.com. (
                        2024030501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      airdrop.it06.com.
@       IN      A       192.236.4.3     ; Stalber
medkit  IN      A       192.236.4.4     ; Lipovka #nambahin ini subdomain
www     IN      CNAME   airdrop.it06.com.
EOF
)

# Overwrite the file with the new content
echo "$new_content" > /etc/bind/jarkom/airdrop.it06.com

service bind9 restart
```

### Testing
```
ping medkit.airdrop.it06.com -c 3
host -t A medkit.airdrop.it06.com
```

### Result
![soal8](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/8.png)

## Soal 9
Terkadang red zone yang pada umumnya di bombardir artileri akan dijatuhi bom oleh pesawat tempur. Untuk melindungi warga, kita diperlukan untuk membuat sistem peringatan air raid dan memasukkannya ke subdomain siren.redzone.xxxx.com dalam folder siren dan pastikan dapat diakses secara mudah dengan menambahkan alias www.siren.redzone.xxxx.com dan mendelegasikan subdomain tersebut ke Georgopol dengan alamat IP menuju radar di Severny
### Pochinki
```
# Update redzone.it06.com zone file
new_zone_content=$(cat <<EOF
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     redzone.it06.com. root.redzone.it06.com. (
                        2024030501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      redzone.it06.com.
@       IN      A       192.236.4.2     ; Serverny
www     IN      CNAME   redzone.it06.com.
ns1     IN      A       192.236.3.2     ; IP Georgopol #nambah ini
siren   IN      NS      ns1 #nambah ini
EOF
)

echo "$new_zone_content" > /etc/bind/jarkom/redzone.it06.com

# Update named.conf.options #nambah ini
new_options_content=$(cat <<EOF
options {
    directory "/var/cache/bind";

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF
)

echo "$new_options_content" > /etc/bind/named.conf.options

# Restart BIND service
service bind9 restart
```

### Georgopol
```
# Set up zone configuration
echo 'zone "siren.redzone.it06.com" {
        type master;
        file "/etc/bind/siren/siren.redzone.it06.com";
};' >> /etc/bind/named.conf.local

# Create directory for zone file
mkdir -p /etc/bind/siren

# Copy db.local to the specified directory
cp /etc/bind/db.local /etc/bind/siren/siren.redzone.it06.com

# Create zone file
cat << EOF > /etc/bind/siren/siren.redzone.it06.com
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     siren.redzone.it06.com. siren.redzone.it06.com. (
                        2024030501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      siren.redzone.it06.com.
@       IN      A       192.236.4.2     ; Serverny
www     IN      CNAME   siren.redzone.it06.com.
EOF

# Update named.conf.options
new_options_content=$(cat <<EOF
options {
    directory "/var/cache/bind";

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF
)

# Restart BIND service
service bind9 restart
```

### Testing
```
ping siren.redzone.it06.com -c 3
ping www.siren.redzone.it06.com -c 3
host -t CNAME www.siren.redzone.it06.com
```

### Result
![soal9](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/9.1.png)
![soal9](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/9.2.png)

## Soal 10
Markas juga meminta catatan kapan saja pesawat tempur tersebut menjatuhkan bom, maka buatlah subdomain baru di subdomain siren yaitu log.siren.redzone.xxxx.com serta aliasnya www.log.siren.redzone.xxxx.com yang juga mengarah ke Severny
```
new_content=$(cat <<'EOF'
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     siren.redzone.it06.com. siren.redzone.it06.com. (
                        2024030501      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      siren.redzone.it06.com.
@       IN      A       192.236.4.2     ; Serverny
www     IN      CNAME   siren.redzone.it06.com.
log     IN      A       192.236.4.2     ; Serverny #nambah ini
www.log IN      CNAME   log #nambah ini
EOF
)

# Simpan konten ke file yang dituju
echo "$new_content" > /etc/bind/siren/siren.redzone.it06.com

# Restart BIND service untuk menerapkan perubahan
service bind9 restart
```

### Testing
```
ping log.siren.redzone.it06.com -c 3
ping www.log.siren.redzone.it06.com -c 3
host -t CNAME www.log.siren.redzone.it06.com
```

### Result
![soal10](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/10.1.png)
![soal10](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/10.2.png)
![soal10](https://github.com/harvdt/Jarkom-Modul-2-IT06-2024/blob/main/image/10.3.png)

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
