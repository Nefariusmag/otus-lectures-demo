# Asnsible roles and collection

ansible-galaxy collection list

ansible-galaxy install -r environments/dev/requirements.yml

ansible-galaxy collection install nginxinc.nginx_core:==0.7.1

ansible-playbook application.yaml -i environments/dev/hosts -e pg_version=15

ansible-galaxy collection init rocky8.rockstarcollection
