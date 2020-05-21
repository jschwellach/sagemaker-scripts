#!/bin/bash


echo "installing conda packages"
sudo -u ec2-user -i <<'EOF'
CONDA_PACKAGES=("nodejs" "ipympl" "ipywidgets")
ENVIRONMENT=mxnet_p36
for p in "${CONDA_PACKAGES[@]}"
do
    echo "installing in base environment..."
    # Note that "base" is special environment name, include it there as well.
    conda install "$p" --name base --yes
    conda install "$p" --name "$ENVIRONMENT" --yes
    # for env in /home/ec2-user/anaconda3/envs/*; do
    #     env_name=$(basename "$env")
    #     if [ $env_name = 'JupyterSystemEnv' ]; then
    #         continue
    #     fi
    #     echo "installing in $env_name environment..."
    #     conda install "$p" --name "$env_name" --yes
    # done
done
EOF
echo "installing conda packages in all environments"

echo "installing lab extensions"
sudo -u ec2-user -i <<'EOF'
LAB_EXTENSIONS=("@jupyterlab/git" "@jupyter-widgets/jupyterlab-manager")
for e in "${LAB_EXTENSIONS[@]}"
do
    echo "installing $e"
    source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
    jupyter labextension install "$e"
    source /home/ec2-user/anaconda3/bin/deactivate
done
EOF
echo "installing lab extensions done"

echo "installing python pip packages"
sudo -u ec2-user -i <<'EOF'
PACKAGES=("scikit-image" "ipympl")
ENVIRONMENT=mxnet_p36
source /home/ec2-user/anaconda3/bin/activate "$ENVIRONMENT"
pip install --upgrade pip
for p in "${PACKAGES[@]}"
do
    pip install --upgrade "$i"
done
source /home/ec2-user/anaconda3/bin/deactivate
EOF
echo "installing python pip packages done"