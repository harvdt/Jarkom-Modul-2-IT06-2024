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