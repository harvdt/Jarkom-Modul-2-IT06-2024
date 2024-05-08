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