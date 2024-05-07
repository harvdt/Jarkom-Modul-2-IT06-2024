echo ';
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
@           IN      NS      siren.redzone.it06.com.
@           IN      A       192.236.4.2     ; Serverny
www         IN      CNAME   siren.redzone.it06.com.
log         IN      A       192.236.4.2     ; Serverny
www.log     IN      CNAME   log.siren.redzone.it06.com.' > /etc/bind/siren/siren.redzone.it06.com

# Restart BIND service
service bind9 restart

echo "Success"