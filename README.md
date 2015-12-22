consul agent -config-file=/vagrant/config/consul-n1.json
consul agent -config-file=/vagrant/config/consul-n2.json

export NOMAD_ADDR=http://172.20.20.10:4646
sudo nomad agent -config=/vagrant/config/nomad-n1.json
export NOMAD_ADDR=http://172.20.20.11:4646
sudo nomad agent -config=/vagrant/config/nomad-n2.json

nomad run /vagrant/config/hello.nomad
