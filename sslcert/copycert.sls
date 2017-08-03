# vim: ft=sls
{% from "sslcert/map.jinja" import sslcert with context %}

{% for destopts in sslcert.gencert.copycert %}
sslcert_copy_cert_{{ destopts.name }}:
  file.managed:
    - name: {{ destopts.name }}
    - source: {{ sslcert.gencert.name }}
    - user: {{ destopts.user }}
    - group: {{ destopts.group }}
    - mode: {{ destopts.mode }}
    - makedirs: True
    - onlyif: test -s {{ sslcert.gencert.name }}

sslcert_copy_key_{{ destopts.name|replace('.crt','.key') }}:
  file.managed:
    - name: {{ destopts.name|replace('.crt','.key') }}
    - source: {{ sslcert.gencert.kwargs.public_key }}
    - user: {{ destopts.user }}
    - group: {{ destopts.group }}
    - mode: {{ destopts.mode }}
    - makedirs: True
    - onlyif: test -s {{ sslcert.gencert.kwargs.public_key }}

sslcert_copy_jks_{{ destopts.name|replace('.crt','.jks') }}:
  file.managed:
    - name: {{ destopts.name|replace('.crt','.jks') }}
    - source: {{ sslcert.gencert.name|replace('.crt','.jks') }}
    - user: {{ destopts.user }}
    - group: {{ destopts.group }}
    - mode: {{ destopts.mode }}
    - makedirs: True
    - onlyif: test -s {{ sslcert.gencert.name|replace('.crt','.jks') }}

sslcert_copy_jks_{{ destopts.name|replace('.crt','.pkcs8.key') }}:
  file.managed:
    - name: {{ destopts.name|replace('.crt','.pkcs8.key') }}
    - source: {{ sslcert.gencert.kwargs.public_key|replace('.key','.pkcs8.key') }}
    - user: {{ destopts.user }}
    - group: {{ destopts.group }}
    - mode: {{ destopts.mode }}
    - makedirs: True
    - onlyif: test -s {{ sslcert.gencert.kwargs.public_key|replace('.key','.pkcs8.key') }}
{% endfor %}
