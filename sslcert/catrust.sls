# vim: ft=sls
{% from "sslcert/map.jinja" import sslcert with context %}

{% for cahost,caname in sslcert.trust.iteritems() %}
sslcert_internal_cacert_file_{{ cahost }}-{{ caname }}:
  file.managed:
    - name: /usr/local/share/ca-certificates/{{ cahost }}-{{ caname }}.crt
    - source: salt://cacerts/{{ cahost }}/{{ caname }}/ca.crt
    - replace: False
    - mode: 644
    - makedirs: true
    - watch_in:
      - cmd: sslcert_update_system_catrust
{% endfor %}

# On Debian, updates /etc/ssl/certs/cacerts and /etc/ssl/certs/java/cacerts
sslcert_update_system_catrust:
  cmd.wait:
    - name: update-ca-certificates
