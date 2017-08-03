haveged:
  pkg.installed: []

/etc/salt/minion.d/signing_policies.conf:
  file.managed:
    - source: salt://test/mockup/files/signing_policies.conf

/etc/salt/master.d/peer.conf:
  file.managed:
    - source: salt://test/mockup/files/peer.conf

/etc/salt/master:
  file.managed:
    - source: salt://test/mockup/files/master

/etc/salt/autosign:
  file.managed:
    - contents:
      - salt

set_hostname:
  cmd.wait:
    - name: hostnamectl set-hostname salt
    - watch:
      - file: /etc/hosts

/etc/hosts:
  file.managed:
    - contents:
      - 127.0.0.1 salt localhost debian
      - 127.0.1.1 salt localhost debian

salt-minion:
  service.running:
    - enable: True
    - listen:
      - file: /etc/salt/minion.d/signing_policies.conf
      - file: /etc/hosts

salt-master:
  service.running:
    - enable: True
    - listen:
      - file: /etc/salt/master
      - file: /etc/salt/master.d/peer.conf
      - file: /etc/salt/autosign
      - file: /etc/hosts

vagrant:
  user.present:
    - gid_from_name: True
