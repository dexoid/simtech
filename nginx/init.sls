{% if grains['os'] == 'CentOS' %}
req.packages:
  pkg.installed:
    - pkgs:
      - epel-release
{% endif %}

{% if grains['os'] == 'CentOS' %}     
php-fpm:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: php-fpm
      - file: /etc/php-fpm.d/www.conf

{% elif grains['os'] == 'Debian' %}

php7.0-fpm:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: php7.0-fpm
      - file: /etc/php/7.0/fpm/pool.d/www.conf
{% endif %}

nginx:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/conf.d/site.conf


/etc/nginx/conf.d/site.conf:
  file.managed:
    - source: salt://nginx/data/etc/nginx/conf.d/site.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - wwwuser: nginx
    - wwwgroup: nginx
    {% if grains['os'] == 'CentOS' %}
    - wwwsock: /var/run/php-fpm/www.sock
    {% elif grains['os'] == 'Debian' %}
    - wwwsock: /tmp/www.sock
    {% endif %}

{% if grains['os'] == 'CentOS' %}
/etc/php-fpm.d/www.conf:
  file.managed:
    - source: salt://nginx/data/etc/php-fpm.d/www.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - wwwuser: nginx
    - wwwgroup: nginx
    - wwwsock: /var/run/php-fpm/www.sock
{% elif grains['os'] == 'Debian' %}
/etc/php/7.0/fpm/pool.d/www.conf:
  file.managed:
    - source: salt://nginx/data/etc/php-fpm.d/www.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - wwwuser: www-data
    - wwwgroup: www-data
    - wwwsock: /tmp/www.sock
{% endif %}

/var/www:
  file.directory:
    {% if grains['os'] == 'CentOS' %}
    - user:  nginx
    - group:  nginx
    {% elif grains['os'] == 'Debian' %}
    - user:  www-data
    - group:  www-data
    {% endif %}
    - name:  /var/www
    - mode:  755

/var/www/index.php:
  file.managed:
    - source: salt://nginx/data/var/www/index.php
    {% if grains['os'] == 'CentOS' %}
    - user: nginx
    - group: nginx
    {% elif grains['os'] == 'Debian' %}
    - user:  www-data
    - group:  www-data
    {% endif %}
    - mode: 755

