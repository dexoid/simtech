{% from "nginx/sites/map.jinja" import map_nginxsites_settings with context %}
{% from "nginx/map.jinja" import map_nginx_settings with context %}

include:
  - nginx

{% for site,params in map_nginxsites_settings.sites.items() %}
{{ site }}-config:
  file.managed:
    - name: /etc/nginx/conf.d/{{ site }}.conf
    - source: {{ params.tmpl | default(map_nginxsites_settings.common.tmpl) }}
    - template: jinja
    - mode: 644
    - owner: root
    - group: root
    - custom_vars:
      params: {{ params }}
      params_common: {{ map_nginxsites_settings.common }}
      site: {{ site }}
    - require:
      - file: {{ site }}-logdirs
    - watch_in:
      - service: nginx

{{ site }}-logdirs:
  file.directory:
    - name: /var/log/nginx/{{ site }}
    - user: {{ map_nginx_settings.params.user }}
    - group: {{ map_nginx_settings.params.group }}
    - mode: 755
    - makedirs: True

{{ site }}-content:
  file.managed:
    - name: /var/www/{{ site }}/index.php
    - source: salt://nginx/data/var/www/index.php
    - mode: 755
    - user: {{ map_nginx_settings.params.user }}
    - group: {{ map_nginx_settings.params.group }}
    - makedirs: True

{% endfor %}

