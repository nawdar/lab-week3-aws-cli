#!/bin/bash
KEY_NAME="bcitkey"
PUBLIC_KEY_FILE="$HOME/.ssh/bcitkey.pem.pub"

aws ec2 import-key-pair \
    --key-name "$KEY_NAME" \
    --public-key-material fileb://"$PUBLIC_KEY_FILE"

echo "Key pair '$KEY_NAME' imported successfully!"
