echo ';
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
medkit  IN      A       192.236.4.4     ; Lipovka
www     IN      CNAME   airdrop.it06.com.
@       IN      AAAA    ::1' > /etc/bind/jarkom/airdrop.it06.com

# Restart BIND service
service bind9 restart

echo "Success"