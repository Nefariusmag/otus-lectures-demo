# Asnsible roles

ansible-galaxy collection install nginxinc.nginx_core
ansible-galaxy collection install crivetimihai.virtualization

ansible-playbook application.yaml -i environments/dev/hosts -e pg_version=15
