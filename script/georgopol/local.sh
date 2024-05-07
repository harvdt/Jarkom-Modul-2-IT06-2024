cat << EOF > /etc/bind/named.conf.local
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

zone "siren.redzone.it06.com" {
    type master;
    file "/etc/bind/siren/siren.redzone.it06.com";
};
EOF

echo "Success"