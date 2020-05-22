#!/bin/bash

set -e

# Installing matplotlib widget support and update Jupyterlab extensions so we can use ipympl
echo "installing lab extensions"
sudo -u ec2-user -i <<'EOF'
LAB_EXTENSIONS=("@jupyterlab/git" "@jupyter-widgets/jupyterlab-manager")
source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
pip install --upgrade pip
pip install ipympl
for e in "${LAB_EXTENSIONS[@]}"
do
    echo "installing $e"
    jupyter labextension install "$e"
done
jupyter lab build
source /home/ec2-user/anaconda3/bin/deactivate
EOF
echo "installing lab extensions done"