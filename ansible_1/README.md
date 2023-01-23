# Ansible 1

## Basic modules

ansible apps -i hosts.ini -m setup

ansible apps -m file -a "dest=/tmp/lol.txt mode=755 state=touch"
ansible apps -m shell -a "ls /tmp/lol.txt"

ansible apps -m apt -a "name=screen state=present" --become  

## Playbooks

ansible-playbook screen.yaml

ansible-playbook -i 158.160.51.5, screen.yaml --check  
