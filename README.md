## Prepare environment for Ansible

This installs 

* some necessary libraries and apps from apt
* pyenv and some plugins
* installs latest version of python 3
* ansible
* python-apt in ansible venv

```
sudo apt update
sudo apt install -y git curl libreadline-dev libssl-dev libbz2-dev libsqlite3-dev
```

then

```
mkdir -p ~/.local/bin
sudo adduser mzuba adm
sudo adduser mzuba staff
curl -sL https://pyenv.run | bash
cat <<'EOF' >> ~/.bashrc

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH="/home/mzuba/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

export ANSIBLE_VAULT_PASSWORD_FILE="$HOME/.ansible-vault"
EOF
exec $SHELL
```

And then this

```
git clone https://github.com/jawshooah/pyenv-default-packages.git "$(pyenv root)"/plugins/pyenv-default-packages
git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
echo "pipenv" > $(pyenv root)/default-packages
pyenv latest install 3
pyenv global `pyenv latest --print-installed 3`
python_version=`pyenv latest --print-installed 3`
python_version=${python_version%.*}
mkdir -p ~/.local/share/pipenvs/ansible
pushd ~/.local/share/pipenvs/ansible
pipenv install ansible github3.py cryptography --skip-lock
venv=`pipenv --venv`
# https://github.com/ansible/ansible/issues/14468#issuecomment-459630445
pushd /tmp
apt download python3-apt
dpkg -x python3-apt_1.8.4.1_amd64.deb python3-apt
cp -r /tmp/python3-apt/usr/lib/python3/dist-packages/* $venv/lib/python${python_version}/site-packages/
pushd $venv/lib/python${python_version}/site-packages/
mv apt_pkg.cpython-37m-x86_64-linux-gnu.so apt_pkg.so
mv apt_inst.cpython-37m-x86_64-linux-gnu.so apt_inst.so
popd
popd
ln -s `pipenv run which ansible` ~/.local/bin/ansible
ln -s `pipenv run which ansible-playbook` ~/.local/bin/ansible-playbook
ln -s `pipenv run which ansible-pull` ~/.local/bin/ansible-pull
ln -s `pipenv run which ansible-vault` ~/.local/bin/ansible-vault
popd
```

Then export an environment variable:

```
export ANSIBLE_VAULT_PASSWORD_FILE=<path to vault password file>
```

Now you can run `ansible-playbook -K local.yml`