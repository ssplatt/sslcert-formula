# sslcert-formula
[![Build Status](https://travis-ci.org/ssplatt/sslcert-formula.svg?branch=master)](https://travis-ci.org/ssplatt/sslcert-formula)

Run an internal CA and automatically generate certificates for minions.

The things in test/mockup{/files} all need to be in place to process requests and most likely should be configured using other formulas in production (i.e. saltstack-formula for the master and minion config things).

## Defaults
```
sslcert:
  enabled: true
  pki_dir: /etc/pki
  ca_minion_id: salt
  keytool: /usr/bin/keytool
  pkg_deps:
    - python-m2crypto
```
The location where the certificates are stored can be changed using the `pki_dir` option. This should be done globally so all hosts store their things in the same place.

If an application comes packaged with their own Java and thus their own keytool binary, you can use it by changing the `keytool` option.

## Certificate Authority
Defining the `ca` section will trigger the creation of a CA certificate and configure the things to allow peer minions to connect and request signed certs. It will also send the CA certificate to the Salt Mine so other minions can install it and trust it. By default, the standard debian ca certificate chains will be updated, using the `update-ca-certificates` command (which will update the system java cacerts keystore, too).
```
sslcert:
  ca:
    testingca:
      cn: localca.local
      c: US
      st: MyState
      l: MyCity
      days_valid: 3650
      days_remaining: 0
    anotherca:
      cn: anotherlocalca.local
      c: US
      st: anotherMyState
      l: anotherMyCity
      days_valid: 3650
      days_remaining: 0
```

## Generate an SSL Certificate
The `gencert` houses information for a local cert. [states.x509.certificate_managed](https://docs.saltstack.com/en/2015.8/ref/states/all/salt.states.x509.html#module-salt.states.x509) can use all the same kwargs as [modules.x509.create_certificate](https://docs.saltstack.com/en/2015.8/ref/modules/all/salt.modules.x509.html#salt.modules.x509.create_certificate)
```
sslcert:
  ca_minion_id: salt
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
      subjectAltName: DNS:myvirthost.local
    java:
      alias: {{ grains.id }}
      password: MyPass11
```
## Copy certificate to another location
Use `copycert` to list different locations and permissions to place the certificate and key. They key name and java keystore name will be derived by replacing .crt in `name`.
```
sslcert:
  gencert:
    copycert:
      - name: /tmp/test/{{ grains.id }}.crt
        user: root
        group: root
        mode: 640
      - name: /tmp/test2/something.crt
        user: root
        group: vagrant
        mode: 640
```


## Add other CAs to trust
You can specify wich CAs you'd like to have the trust certificate for.
```
sslcert:
  trust:
    - testingca
	- anotherca
```

## Development
Install and setup brew:
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

```
brew install cask
brew cask install vagrant
```

```
cd <formula dir>
bundle install
```
or
```
sudo gem install test-kitchen
sudo gem install kitchen-vagrant
sudo gem install kitchen-salt
```

Run a converge on the default configuration:
```
kitchen converge default
```
