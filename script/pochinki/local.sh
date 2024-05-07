cat <<EOF > /etc/bind/named.conf.local
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

echo "Success"