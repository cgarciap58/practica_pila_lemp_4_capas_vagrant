sudo apt update
sudo apt install haproxy -y


cat > /etc/haproxy/haproxy.cfg << 'EOF'
frontend mysql_front
    bind *:3306
    mode tcp
    default_backend mysql_back

backend mysql_back
    mode tcp
    balance roundrobin
    server db1 192.168.40.7:3306 check
    server db2 192.168.40.8:3306 check
EOF

sudo systemctl enable haproxy
sudo systemctl restart haproxy
