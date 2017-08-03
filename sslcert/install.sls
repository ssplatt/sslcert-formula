{% from "sslcert/map.jinja" import sslcert with context %}

sslcert_dependencies:
  pkg.installed:
    - pkgs: {{ sslcert.pkg_deps }}
