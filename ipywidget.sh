#!/bin/bash

PACKAGES=("scikit-image" "ipympl")
CONDA_PACKAGES=("nodejs" "ipympl" "ipywidgets")
LAB_EXTENSIONS=("@jupyterlab/git" "@jupyter-widgets/jupyterlab-manager")
ENVIRONMENT=mxnet_p36

echo "installing conda packages in all environments"
for p in "${CONDA_PACKAGES[@]}"
do
    echo "installing in base environment..."
    # Note that "base" is special environment name, include it there as well.
    conda install "$p" --name base --yes
    for env in /home/ec2-user/anaconda3/envs/*; do
        env_name=$(basename "$env")
        if [ $env_name = 'JupyterSystemEnv' ]; then
            continue
        fi
        echo "installing in $env_name environment..."
        conda install "$p" --name "$env_name" --yes
    done
done
echo "installing conda packages done..."
echo "installing lab extensions"
for e in "${LAB_EXTENSIONS[@]}"
do
    echo "installing $e"
    source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
    jupyter labextension install "$e"
    source /home/ec2-user/anaconda3/bin/deactivate
done
echo "installing lab extensions done"
echo "installing python pip packages"
source /home/ec2-user/anaconda3/bin/activate "$ENVIRONMENT"
pip install --upgrade pip
for p in "${PACKAGES[@]}"
do
    pip install --upgrade "$i"
done
source /home/ec2-user/anaconda3/bin/deactivate