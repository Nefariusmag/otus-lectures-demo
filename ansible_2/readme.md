# Ansible 2

## Crypt

ansible-playbook postgres.yaml

ansible-playbook postgres.yaml --ask-vault-pass

ansible-vault decrypt vars.yaml  

ansible-playbook postgres.yaml

ansible-vault encrypt vars.yaml

## Tag

ansible-playbook postgres.yaml --ask-vault-pass --tags install,update
ansible-playbook postgres.yaml --ask-vault-pass --tags one


## Debug

ansible-playbook postgres.yaml --ask-vault-pass -vv

ansible-playbook postgres.yaml --ask-vault-pass --step

// enable debug

p task
p task.args
p task.args['data']
task.args['data']="lol"
r

p vars['wrong_var']
