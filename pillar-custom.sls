# vim: ft=yaml
# Custom Pillar Data for sslcert

sslcert:
  ca_minion_id: salt
  ca:
    testingca:
      cn: {{ grains.id }}
      c: US
      st: MyState
      l: MyCity
      days_valid: 3650
      days_remaining: 0
  trust:
    salt: testingca
  gencert:
    name: /etc/pki/{{ grains.id }}.crt
    days_remaining: 30
    user: vagrant
    group: vagrant
    mode: 640
    kwargs:
      ca_server: salt
      signing_policy: testingca
      CN: {{ grains.id }}
      days_valid: 90
      public_key: /etc/pki/{{ grains.id }}.key
      subjectAltName: DNS:myvirthost.local, DNS:{{ grains.id }}
    java:
      alias: {{ grains.id }}
      password: MyPass11
    pkcs8: true
    copycert:
      - name: /tmp/test/{{ grains.id }}.crt
        user: root
        group: root
        mode: 640
      - name: /tmp/test2/something.crt
        user: root
        group: vagrant
        mode: 640
