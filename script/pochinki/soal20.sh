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
