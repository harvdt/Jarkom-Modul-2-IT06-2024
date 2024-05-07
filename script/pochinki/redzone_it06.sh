echo ';
; BIND data file for local loopback interface
;
$TTL    604800
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
ns1     IN      A       192.236.3.2     ; IP Georgopol
siren   IN      NS      ns1
@       IN      AAAA    ::1' > /etc/bind/jarkom/redzone.it06.com

# Restart BIND service
service bind9 restart

echo "Success"