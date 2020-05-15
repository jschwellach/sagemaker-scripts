#!/bin/bash

# Install required library
sudo -u ec2-user -i <<'EOF'
# PARAMETERS
PACKAGES=("scikit-image" "ipympl")
EXTENSION_NAMES=("@jupyterlab/git" "@jupyter-widgets/jupyterlab-manager jupyter-matplotlib")
ENVIRONMENT=mxnet_p36

source /home/ec2-user/anaconda3/bin/activate "$ENVIRONMENT"
echo "installing conda-forge and nodejs"
nohup conda install -c conda-forge nodejs -y&
echo "conda install done"

pip install --upgrade pip
for i in "${PACKAGES[@]}"
do
    echo "installing $i with pip"
    pip install --upgrade pip "$i" &
done


for extension in "${EXTENSION_NAMES[@]}"
do
    echo "installing $extension with labextension"
    jupyter labextension install $extension
done

source /home/ec2-user/anaconda3/bin/deactivate
