{% from "nginx/map.jinja" import map_nginx_settings with context %}

include:
  - ../common/yum/epel

nginx_user:
  user.present:
    - name: {{ map_nginx_settings.params.user }}
    - home: /var/cache/{{ map_nginx_settings.params.user }}
    - shell: /sbin/nologin
    - fullname: nginx user

nginx:
  pkg.installed:
    - name: nginx
  service.running:
    - name: nginx
    - enable: true
    - reload: true
    - require:
      - user: nginx_user

nginx_config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/data/etc/nginx/nginx.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - params: {{ map_nginx_settings.params }}
    - watch_in:
      - service: nginx

