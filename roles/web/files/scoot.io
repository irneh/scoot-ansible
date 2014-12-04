ssl_certificate /etc/ssl/www.scoot.io.crt;
ssl_certificate_key /etc/ssl/www.scoot.io.key;
ssl_session_cache shared:SSL:10m;

server {
    listen 443;
    ssl on;
    server_name .scoot.io;
    client_max_body_size 50M;
    client_body_buffer_size 50M;
    access_log  /var/log/nginx/scoot.com.access.log;

    add_header Cache-Control public;
    add_header Vary: Origin;
    add_header Vary: Accept-Encoding;

    gzip on;
    gzip_comp_level 5;
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/x-javascript application
    gzip_vary on;

    root /home/ubuntu/hikerpix/web2py/applications/hikerpix;

    location / {
        rewrite ^/sitemap\.xml$ /sitemap_xml;
        include uwsgi_params;
        uwsgi_pass localhost:3031;
        if ($http_origin ~* "https://(|.*\.)scoot\.io") {
            add_header 'Access-Control-Allow-Origin' "$http_origin";
        }
    }

    location /static/dynamic/ {
        expires 5m;
        gzip_http_version 1.0;
        gzip_static on;
        if ($http_origin ~* "https://(|.*\.)scoot\.io") {
            add_header 'Access-Control-Allow-Origin' "$http_origin";
        }
    }

    location /static/ {
        expires 31d;
        gzip_http_version 1.0;
        gzip_static on;
        if ($http_origin ~* "https://(|.*\.)scoot\.io") {
            add_header 'Access-Control-Allow-Origin' "$http_origin";
        }
    }
}

server {
    listen 80;
    server_name *.scoot.io *.hikerpix.com;
    location / {
      return 301 https://scoot.io$request_uri;
    }
}

server {
    listen 443;
    ssl on;
    server_name localhost .hikerpix.com;
    location / {
        return 301 https://scoot.io$request_uri;
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
