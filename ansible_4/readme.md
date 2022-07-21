
ansible-lint nginx.yaml
yamllint nginx.yaml

ANSIBLE_NOCOWS=0

python3 -m venv ./venv

pip install --user ansible==2.9 "molecule[docker]" pytest-testinfra==6.3.0 pytest==6.2.4 ansible-lint cowsay

molecule init scenario default -r nginx -d delegated
#molecule init role derokhin.postgres1 --driver-name docker
#molecule init role -d docker --verifier-name testinfra derokhin.postgres1
