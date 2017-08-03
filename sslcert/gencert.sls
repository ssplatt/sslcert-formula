# vim: ft=sls
{% from "sslcert/map.jinja" import sslcert with context %}
{% set caname = sslcert.trust[sslcert.gencert.kwargs.ca_server] %}

sslcert_pki_dir:
  file.directory:
    - name: {{ sslcert.pki_dir }}

sslcert_gen_key:
  x509.private_key_managed:
    - name: {{ sslcert.gencert.kwargs.public_key }}
    - bits: 4096

{% if sslcert.gencert.user is defined and
sslcert.gencert.group is defined and
sslcert.gencert.mode is defined %}
sslcert_gen_key_perms:
  file.managed:
    - name: {{ sslcert.gencert.kwargs.public_key }}
    - user: {{ sslcert.gencert.user }}
    - group: {{ sslcert.gencert.group }}
    - mode: {{ sslcert.gencert.mode }}
    - replace: False
    - onlyif: test -s {{ sslcert.gencert.kwargs.public_key }}
{% endif %}

sslcert_gen_cert:
  x509.certificate_managed:
    - name: {{ sslcert.gencert.name }}
    - days_remaining: {{ sslcert.gencert.days_remaining }}
    - backup: True
    {% for k, v in sslcert.gencert.kwargs.iteritems() -%}
    - {{ k }}: {{ v }}
    {% endfor %}
    - unless: test -s {{ sslcert.gencert.name }}

{% if sslcert.gencert.user is defined and
sslcert.gencert.group is defined and
sslcert.gencert.mode is defined %}
sslcert_gen_cert_perms:
  file.managed:
    - name: {{ sslcert.gencert.name }}
    - user: {{ sslcert.gencert.user }}
    - group: {{ sslcert.gencert.group }}
    - mode: {{ sslcert.gencert.mode }}
    - replace: False
    - onchanges:
      - x509: sslcert_gen_cert
{% endif %}

{% if sslcert.gencert.java is defined %}
# add cert to java keystore for java apps to use
sslcert_gen_convert_to_p12:
  cmd.run:
    - name: openssl pkcs12 -export -name {{ sslcert.gencert.java.alias }} -in {{ sslcert.gencert.name }} -inkey {{ sslcert.gencert.kwargs.public_key }} -out {{ sslcert.gencert.name|replace('.crt','.p12') }} -passout pass:{{ sslcert.gencert.java.password }}
    - onlyif: test -s {{ sslcert.gencert.name }}
    - unless: test -s {{ sslcert.gencert.name|replace('.crt','.p12') }}

{%   if sslcert.gencert.user is defined and
sslcert.gencert.group is defined and
sslcert.gencert.mode is defined %}
sslcert_gen_convert_to_p12_perms:
  file.managed:
    - name: {{ sslcert.gencert.name|replace('.crt','.p12') }}
    - user: {{ sslcert.gencert.user }}
    - group: {{ sslcert.gencert.group }}
    - mode: {{ sslcert.gencert.mode }}
    - replace: False
    - onlyif: test -s {{ sslcert.gencert.name|replace('.crt','.p12') }}
{%   endif %}

{%   if sslcert.keytool == "/usr/bin/keytool" %}
sslcert_gen_jre_installed:
  pkg.installed:
    - name: {{ sslcert.jre_pkg }}
    - unless: test -x {{ sslcert.keytool }}
{%   endif %}

sslcert_gen_convert_to_java_keystore:
  cmd.run:
    - name: {{ sslcert.keytool }} -importkeystore -trustcacerts -alias {{ sslcert.gencert.java.alias }} -srckeystore {{ sslcert.gencert.name|replace('.crt','.p12') }} -srcstoretype pkcs12 -srcstorepass {{ sslcert.gencert.java.password }} -destkeystore {{ sslcert.gencert.name|replace('.crt','.jks') }} -destkeypass {{ sslcert.gencert.java.password }} -deststorepass {{ sslcert.gencert.java.password }}
    - onlyif: test -s {{ sslcert.gencert.name|replace('.crt','.p12') }}
    - unless: test -s {{ sslcert.gencert.name|replace('.crt','.jks') }}

sslcert_gen_import_cacert_to_keystore:
  cmd.wait:
    - name: yes | {{ sslcert.keytool }} -import -trustcacerts -alias {{ sslcert.gencert.kwargs.signing_policy }} -keystore {{ sslcert.gencert.name|replace('.crt','.jks') }} -storepass {{ sslcert.gencert.java.password }} -file /usr/local/share/ca-certificates/{{ sslcert.gencert.kwargs.ca_server }}-{{ caname }}.crt
    - onlyif: test -s /usr/local/share/ca-certificates/{{ sslcert.gencert.kwargs.ca_server }}-{{ caname }}.crt
    - onlyif: test -s {{ sslcert.gencert.name|replace('.crt','.jks') }}
    - watch:
      - cmd: sslcert_gen_convert_to_java_keystore

{%   if sslcert.gencert.user is defined and
sslcert.gencert.group is defined and
sslcert.gencert.mode is defined %}
sslcert_gen_java_keystore_perms:
  file.managed:
    - name: {{ sslcert.gencert.name|replace('.crt','.jks') }}
    - user: {{ sslcert.gencert.user }}
    - group: {{ sslcert.gencert.group }}
    - mode: {{ sslcert.gencert.mode }}
    - replace: False
    - onlyif: test -s {{ sslcert.gencert.name|replace('.crt','.jks') }}
{%   endif %}
{% endif %}

{% if sslcert.gencert.pkcs8 is defined and sslcert.gencert.pkcs8 %}
ssl_gen_cert_conv_key_pkcs8:
  cmd.run:
    - name: openssl pkcs8 -in {{ sslcert.gencert.kwargs.public_key }} -topk8 -out {{ sslcert.gencert.kwargs.public_key|replace('.key','.pkcs8.key') }} -nocrypt
    - onlyif: test -s {{ sslcert.gencert.kwargs.public_key }}
    - unless: test -s {{ sslcert.gencert.kwargs.public_key|replace('.key','.pkcs8.key') }}
{% endif %}
