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
2       IN      PTR     redzone.it06.com. ; Byte ke-4 Servery
EOF

# Restart BIND service
service bind9 restart

echo "Success"