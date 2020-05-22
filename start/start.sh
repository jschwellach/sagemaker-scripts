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
source /home/ec2-user/anaconda3/bin/deactivate
EOF
echo "installing lab extensions done"

# Installing some extra packages within the mxnet_p36 environment
echo "installing python pip packages"
sudo -u ec2-user -i <<'EOF'
PACKAGES=("scikit-image" "ipympl")
ENVIRONMENT=mxnet_p36
source /home/ec2-user/anaconda3/bin/activate "$ENVIRONMENT"
pip install --upgrade pip
for p in "${PACKAGES[@]}"
do
    pip install --upgrade "$p"
done
source /home/ec2-user/anaconda3/bin/deactivate
EOF
echo "installing python pip packages done"


# Install example dataset from Amazon for training and CV workshop
echo "downloading example dataset"
sudo -u ec2-user -i << EOF
# Download dataset (if removed from tmp folder)
BASEURL="https://d8mrh1kj01ho9.cloudfront.net/workshop/cv1/data/"
FILES='example_dataset.pkl training_data.pkl test_data.pkl sample_model_output.csv'
for file in $FILES; do
  [ ! -f "/tmp/$file" ] && cd /tmp && { curl -O "$BASEURL$file" ; cd -; }
done
EOF
echo "download done"

# OVERVIEW
# This script stops a SageMaker notebook once it's idle for more than 1 hour (default time)
# You can change the idle time for stop using the environment variable below.
# If you want the notebook the stop only if no browsers are open, remove the --ignore-connections flag
#
# Note that this script will fail if either condition is not met
#   1. Ensure the Notebook Instance has internet connectivity to fetch the example config
#   2. Ensure the Notebook Instance execution role permissions to SageMaker:StopNotebookInstance to stop the notebook 
#       and SageMaker:DescribeNotebookInstance to describe the notebook.
#
# PARAMETERS
IDLE_TIME=3600
echo "Fetching the autostop script"
wget https://raw.githubusercontent.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples/master/scripts/auto-stop-idle/autostop.py
echo "Starting the SageMaker autostop script in cron"
(crontab -l 2>/dev/null; echo "5 * * * * /usr/bin/python $PWD/autostop.py --time $IDLE_TIME --ignore-connections") | crontab -