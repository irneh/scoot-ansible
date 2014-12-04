ssl_certificate /etc/ssl/www.scoot.io.crt;
ssl_certificate_key /etc/ssl/www.scoot.io.key;
ssl_session_cache shared:SSL:10m;

upstream backend {
    ip_hash;
    server web01.prd.lan.scoot.io:443;
    server web02.prd.lan.scoot.io:443;
}

server {
    listen 80;
    server_name .scoot.io;
    location / {
      return 301 https://$http_host$request_uri;
    }
}

server {
    listen 443;
    ssl on;

    server_name .scoot.io;
    client_max_body_size 50M;
    client_body_buffer_size 50M;
    access_log  /var/log/nginx/scoot.com.access.log;

    location / {
        proxy_pass https://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

}

server {
    listen 80;
    server_name localhost;
    location /nginx_status {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        deny all;
    }
    location /admin {
        allow 127.0.0.1;
        deny all;
    }
}
