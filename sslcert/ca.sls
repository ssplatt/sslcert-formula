{% from "sslcert/map.jinja" import sslcert with context %}

{%   for caname,cadata in sslcert.ca.iteritems() %}
sslcert_ca_pki_issued_dir_{{ caname }}:
  file.directory:
    - name: {{ sslcert.pki_dir }}/{{ caname }}/issued_certs
    - makedirs: true

sslcert_ca_key_gen_{{ caname }}:
  x509.private_key_managed:
    - name: {{ sslcert.pki_dir }}/{{ caname }}/ca.key
    - bits: 4096
    - backup: True

sslcert_ca_cert_gen_{{ caname }}:
  x509.certificate_managed:
    - name: {{ sslcert.pki_dir }}/{{ caname }}/ca.crt
    - signing_private_key: {{ sslcert.pki_dir }}/{{ caname }}/ca.key
    - CN: {{ cadata.cn }}
    - C: {{ cadata.c }}
    - ST: {{ cadata.st }}
    - L: {{ cadata.l }}
    - basicConstraints: "critical CA:true"
    - keyUsage: "critical cRLSign, keyCertSign"
    - subjectKeyIdentifier: hash
    - authorityKeyIdentifier: keyid,issuer:always
    - days_valid: {{ cadata.days_valid }}
    - days_remaining: {{ cadata.days_remaining }}
    - backup: True
    - watch:
      - x509: sslcert_ca_key_gen_{{ caname }}

sslcert_ca_cert_mine_send_{{ caname }}:
  module.run:
    - name: mine.send
    - func: x509.get_pem_entries
    - kwargs:
        glob_path: {{ sslcert.pki_dir }}/{{ caname }}/ca.crt
    - onchanges:
      - x509: sslcert_ca_cert_gen_{{ caname }}
{%   endfor %}

# cache all ca certs to a file root to serve to minions
{%   for k,v in sslcert.trust.iteritems() %}
{%     set _m = salt.mine.get(k, 'x509.get_pem_entries') %}
{%     if _m %}
sslcert_ca_cert_cache_dir_{{ k }}-{{ v }}:
  file.directory:
    - name: {{ sslcert.ca_cache_root }}/cacerts/{{ k }}/{{ v }}
    - makedirs: true
    - mode: 755

sslcert_ca_cert_cache_file_{{ k }}-{{ v }}:
  x509.pem_managed:
    - name: {{ sslcert.ca_cache_root }}/cacerts/{{ k }}/{{ v }}/ca.crt
    - text: {{ _m[k][sslcert.pki_dir ~ '/' ~ v ~ '/ca.crt'] | replace('\n', '') }}
{%     endif %}
{%   endfor %}
