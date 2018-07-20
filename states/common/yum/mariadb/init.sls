{%- from "common/yum/mariadb/map.jinja" import map_mariadb_repo_settings with context -%}
mariadb_repo:
  pkgrepo.managed:
    - name: mariadb
    - humanname: MariaDB-Repo
    - baseurl: http://yum.mariadb.org/{{ map_mariadb_repo_settings.params.version }}/centos7-amd64
    - gpgcheck: 1
    - gpgkey: https://yum.mariadb.org/RPM-GPG-KEY-MariaDB

