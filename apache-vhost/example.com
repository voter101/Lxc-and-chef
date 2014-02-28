<VirtualHost *:80>
    ServerName example.com
    ServerAlias www.example.com
    ProxyPreserveHost On
    ProxyRequests off
    ProxyPass / http://192.168.122.10/
    ProxyPassReverse / http://192.168.122.10/
</VirtualHost>
