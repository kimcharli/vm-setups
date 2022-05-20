# 

## nginx setup for static web/file server

CentOS case
```
yum install nginx

/etc/nginx/nginx.conf

        #root         /usr/share/nginx/html;
        root         /var/nginx/data;
        location / {
          autoindex on;
        }

mkdir -p /var/nginx/data
chown -R nginx: /var/nginx/data

yum provides /usr/sbin/semanage
yum install policycoreutils-python
semanage fcontext -a -t httpd_sys_content_t /var/nginx/data/
```

```
sudo restorecon -v jinstall-host-qfx-5e-x86-64-20.4R3.8-secure-signed.tgz
sudo semanage fcontext -a -t httpd_sys_content_t jinstall-host-qfx-5e-x86-64-20.4R3.8-secure-signed.tgz
```


Upload files
```
sudo mv jinstall-host-qfx-* /var/nginx/data/
sudo chown -R nginx: /var/nginx/data/
```

Incase of ...
```
sudo firewall-cmd  --add-service=http
sudo firewall-cmd  --add-service=http --permanent
```

