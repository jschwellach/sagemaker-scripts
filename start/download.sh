#!/bin/bash

set -e

# Install example dataset from Amazon for training and CV workshop
echo "downloading example dataset"
sudo -u ec2-user -i << 'EOF'
# Download dataset (if removed from tmp folder)
BASEURL="https://d8mrh1kj01ho9.cloudfront.net/workshop/cv1/data/"
FILES='example_dataset.pkl training_data.pkl test_data.pkl sample_model_output.csv'
for file in $FILES; do
  [ ! -f "/tmp/$file" ] && cd /tmp && { curl -O "$BASEURL$file" ; cd -; }
done
EOF
echo "download done"