{%- from "common/yum/mariadb/map.jinja" import map_mariadb_repo_settings with context -%}
# Completely ignore non-RHEL based systems
{% if grains['os_family'] == 'RedHat' %}
mariadb_repo:
  pkgrepo.managed:
    - name: mariadb
    - humanname: MariaDB-Repo
    - baseurl: http://yum.mariadb.org/{{ map_mariadb_repo_settings.params.version }}/centos{{ grains['osmajorrelease'] }}-amd64
    - gpgcheck: 1
    - gpgkey: https://yum.mariadb.org/RPM-GPG-KEY-MariaDB

{% endif %}
