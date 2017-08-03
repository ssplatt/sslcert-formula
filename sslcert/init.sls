# vim: ft=sls
{% from "sslcert/map.jinja" import sslcert with context %}
{% set _c = salt['config.get']('file_client') %}

{% if sslcert.enabled %}
include:
  - sslcert.install
  {% if _c == "remote" -%}
  {%   if sslcert.ca is defined -%}
  - sslcert.ca
  {%-   endif %}
  - sslcert.catrust
  {%   if sslcert.gencert is defined -%}
  - sslcert.gencert
  {%     if sslcert.gencert.copycert is defined -%}
  - sslcert.copycert
  {%-    endif %}
  {%-   endif %}
  {%- endif %}
{% else %}
sslcert-formula_disabled:
  test.succeed_without_changes
{% endif %}
