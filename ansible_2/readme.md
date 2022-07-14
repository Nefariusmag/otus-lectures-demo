ansible-vault encrypt vars.yaml 

ansible-vault decrypt vars.yaml  

ansible-playbook postgres.yaml --ask-vault-pass

ansible-playbook postgres.yaml --ask-vault-pass --step

p task
p task.args
p task.args['data']
task.args['data']='lol'
r

p vars['wrong_var']
