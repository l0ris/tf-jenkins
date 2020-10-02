#!/bin/bash 
sudo yum update -y
sudo yum install -y docker git
sudo amazon-linux-extras install nginx1.12 -y
sudo yum install -y java-1.8.0-openjdk-devel
sudo yum remove -y java-1.7.0-openjdk-1.7.0.231-2.6.19.1.80.amzn1.x86_64
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo cat >> ~/nginx.conf << EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    index   index.html index.htm;

  server {
      listen       80;
      server_name  _;

      location / {
              proxy_pass http://127.0.0.1:8080;
      }
  }
}
EOF

sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
sudo mv ~/nginx.conf /etc/nginx/nginx.conf
sudo chmod 644 /etc/nginx/nginx.conf

sudo chkconfig jenkins on
sudo chkconfig nginx on

sudo service jenkins start
sudo service nginx start

sudo cat /var/log/jenkins/jenkins.log
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
