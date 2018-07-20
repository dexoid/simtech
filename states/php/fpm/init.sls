{% from "php/fpm/map.jinja" import map_phpfpm_settings with context %}

php-fpm-user:
  user.present:
    - name: {{ map_phpfpm_settings.params.user }}
    - home: /home/{{ map_phpfpm_settings.params.user }}
    - shell: /sbin/nologin
    - fullname: php-fpm user

php-fpm-pkgs:
  pkg.installed:
    - pkgs: {{ map_phpfpm_settings.pkgs }}
  service.running:
    - name: {{ map_phpfpm_settings.service }}
    - enable: true
    - reload: true

php-fpm-pool:
  file.managed:
    - name: {{ map_phpfpm_settings.config }}
    - source: salt://php/fpm/files/etc/php-fpm.d/www.conf.j2
    - template: jinja
    - owner: root
    - group: root
    - mode: 644
    - custom:
      params: {{ map_phpfpm_settings.params }}
    - require:
      - pkg: php-fpm-pkgs
    - watch_in:
      - service: php-fpm-pkgs
