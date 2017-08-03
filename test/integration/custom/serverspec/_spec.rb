require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/pki/salt.crt') do
  it { should exist }
  its(:size) { should > 0 }
  its(:content) { should match /-----BEGIN CERTIFICATE-----/ }
  its(:content) { should match /-----END CERTIFICATE-----/ }
end

describe file('/etc/pki/salt.key') do
  it { should exist }
  its(:size) { should > 0 }
  its(:content) { should match /-----BEGIN RSA PRIVATE KEY-----/ }
  its(:content) { should match /-----END RSA PRIVATE KEY-----/ }
end

describe file('/etc/pki/salt.pkcs8.key') do
  it { should exist }
  its(:size) { should > 0 }
  its(:content) { should match /-----BEGIN PRIVATE KEY-----/ }
  its(:content) { should match /-----END PRIVATE KEY-----/ }
end

describe file('/usr/local/share/ca-certificates/salt-testingca.crt') do
  it { should exist }
  its(:size) { should > 0 }
  its(:content) { should match /-----BEGIN CERTIFICATE-----/ }
  its(:content) { should match /-----END CERTIFICATE-----/ }
end

describe file('/etc/pki/testingca/ca.crt') do
  it { should exist }
  its(:size) { should > 0 }
  its(:content) { should match /-----BEGIN CERTIFICATE-----/ }
  its(:content) { should match /-----END CERTIFICATE-----/ }
end

describe file('/etc/pki/testingca/ca.key') do
  it { should exist }
  its(:size) { should > 0 }
  its(:content) { should match /-----BEGIN RSA PRIVATE KEY-----/ }
  its(:content) { should match /-----END RSA PRIVATE KEY-----/ }
end

describe file('/etc/pki/testingca/issued_certs') do
  it { should exist }
  it { should be_directory }
end

describe package('python-m2crypto') do
  it { should be_installed }
end

describe file('/tmp/test/salt.crt') do
  it { should exist }
  its(:size) { should > 0 }
  it { should be_mode 640 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  its(:content) { should match /-----BEGIN CERTIFICATE-----/ }
  its(:content) { should match /-----END CERTIFICATE-----/ }
end

describe file('/tmp/test/salt.key') do
  it { should exist }
  its(:size) { should > 0 }
  it { should be_mode 640 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  its(:content) { should match /-----BEGIN RSA PRIVATE KEY-----/ }
  its(:content) { should match /-----END RSA PRIVATE KEY-----/ }
end

describe file('/tmp/test/salt.pkcs8.key') do
  it { should exist }
  its(:size) { should > 0 }
  it { should be_mode 640 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  its(:content) { should match /-----BEGIN PRIVATE KEY-----/ }
  its(:content) { should match /-----END PRIVATE KEY-----/ }
end

describe file('/tmp/test/salt.jks') do
  it { should exist }
  it { should be_mode 640 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  its(:size) { should > 0 }
end

describe file('/tmp/test2/something.crt') do
  it { should exist }
  its(:size) { should > 0 }
  it { should be_mode 640 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "vagrant" }
  its(:content) { should match /-----BEGIN CERTIFICATE-----/ }
  its(:content) { should match /-----END CERTIFICATE-----/ }
end

describe file('/tmp/test2/something.key') do
  it { should exist }
  its(:size) { should > 0 }
  it { should be_mode 640 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "vagrant" }
  its(:content) { should match /-----BEGIN RSA PRIVATE KEY-----/ }
  its(:content) { should match /-----END RSA PRIVATE KEY-----/ }
end

describe file('/tmp/test2/something.pkcs8.key') do
  it { should exist }
  its(:size) { should > 0 }
  it { should be_mode 640 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "vagrant" }
  its(:content) { should match /-----BEGIN PRIVATE KEY-----/ }
  its(:content) { should match /-----END PRIVATE KEY-----/ }
end

describe file('/tmp/test2/something.jks') do
  it { should exist }
  it { should be_mode 640 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "vagrant" }
  its(:size) { should > 0 }
end
