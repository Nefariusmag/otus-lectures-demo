# Ansible test

ansible-playbook nginx.yaml --check

ansible-lint nginx.yaml
yamllint nginx.yaml

ANSIBLE_NOCOWS=0


---

sudo yum install wget git -y
wget https://download.virtualbox.org/virtualbox/7.0.6/VirtualBox-7.0-7.0.6_155176_el7-1.x86_64.rpm
sudo yum install VirtualBox-7.0-7.0.6_155176_el7-1.x86_64.rpm -y

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vagrant

sudo yum install kernel-devel kernel-devel-3.10.0-1160.el7.x86_64 gcc make perl -y

sudo /sbin/vboxconfig

git clone https://github.com/Nefariusmag/otus-lectures-demo.git

python3 -m venv ./venv


pip install --user ansible==2.9 "molecule[docker]" pytest-testinfra==6.3.0 pytest==6.2.4 ansible-lint cowsay

molecule init scenario default -r nginx -d delegated
#molecule init role derokhin.postgres1 --driver-name docker
#molecule init role -d docker --verifier-name testinfra derokhin.postgres1
