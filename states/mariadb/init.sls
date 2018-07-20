{% from "mariadb/map.jinja" import map_mariadb_settings with context %}
mariadb-server:
  pkg:
    - installed
    - pkgs:
      - MariaDB-server
      - python34-mysql
  service:
    - running
    - name: mariadb
    - enable: True
    - require:
      - pkg: mariadb-server

mariadb-config:
  file.managed:
    - name: /etc/my.cnf.d/server.cnf
    - source: salt://mariadb/files/etc/my.cnf.d/server.cnf.j2
    - template: jinja
    - owner: root
    - group: root
    - mode: 644
    - require:
      - pkg: mariadb-server
    - watch_in:
      - service: mariadb-server
    - custom:
      params: {{ map_mariadb_settings.params.config }}
