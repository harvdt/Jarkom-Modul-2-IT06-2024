echo ';
;
; BIND data file for local loopback interface
;
$TTL    604800
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
@       IN      AAAA    ::1' > /etc/bind/jarkom/loot.it06.com

# Restart BIND service
service bind9 restart

echo "Success"