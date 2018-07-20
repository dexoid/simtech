# Completely ignore non-RHEL based systems
{% if grains['os_family'] == 'RedHat' %}

{% from "common/yum/remi/map.jinja" import pkg with context %}
{% from "common/yum/remi/map.jinja" import map_remi_settings with context %}

install_remi_pubkey:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
    - source: {{ map_remi_settings.pubkey|default(pkg.key) }}
    - source_hash:  {{ map_remi_settings.pubkey_hash|default(pkg.key_hash) }}

include:
    - ../epel

install_remi_rpm:
  pkg.installed:
    - sources:
      - remi-release: {{ map_remi_settings.rpm|default(pkg.rpm) }}
    - requires:
      - file: install_remi_pubkey
      - pkg: epel

{% for repo,opt in map_remi_settings.repo.items() %}
configure-{{ repo }}:
  pkgrepo.managed:
    - name: {{ repo }}
    - {{ opt }}
{% endfor %}
{% endif %}

