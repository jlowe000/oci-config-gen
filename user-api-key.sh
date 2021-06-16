#!/bin/sh
# Determine current (if the current user is an OCI IAM User)
export USER=`oci iam user list | jq -r ".data | map(select(.id == \"$OCI_CS_USER_OCID\"))"`
echo $USER
# Determine current (if the current user is an OCI IDCS User)
if [ "$USER" == "[]" ]; then
  export USER=`oci iam user list | jq -r ".data | map(select( (.\"identity-provider-id\" == (\"$OCI_CS_USER_OCID\" | split(\"/\") | .[0])) and ((.name | split(\"/\") | .[1]) == (\"$OCI_CS_USER_OCID\" | split(\"/\") | .[1]) ) ))"`
  echo $USER
fi
# Capture User's OCID
export USER_OCID=`echo $USER | jq -r ".[].id"`
echo $USER_OCID
# Capture Tenancy's OCID
echo $OCI_TENANCY
# Determine region's three letter code
export HOME_REGION=`oci iam tenancy get --tenancy-id $OCI_TENANCY | jq -r '.data."home-region-key"'`
# Capture region's name 
export HOME_REGION_NAME=`oci iam region list | jq -r ".data | map(select(.key == \"$HOME_REGION\")) | .[].name"`
export NOW=`date +"%Y%m%d"`
# Create a new key
oci setup keys --passphrase "WelcomeTiger" --key-name oci_api_key_$NOW
# Upload key to the current user and capture the fingerprint
export FINGERPRINT=`oci iam user api-key upload --user-id $USER_OCID --key-file ~/.oci/oci_api_key_${NOW}_public.pem | jq -r ".data.fingerprint"`
# Capture bucket namespace
export BUCKET_NS=`oci os ns get | jq -r '.data'`

echo "[DEFAULT]" > ~/.oci/config
echo "user=$USER_OCID" >> ~/.oci/config
echo "fingerprint=$FINGERPRINT" >> ~/.oci/config
echo "tenancy=$OCI_TENANCY" >> ~/.oci/config
echo "region=$HOME_REGION_NAME" >> ~/.oci/config
echo "key_file=~/.oci/oci_api_key_${NOW}.pem" >> ~/.oci/config

echo "# Export of key tenant variables" > ~/.oci/.oci_profile
echo "export TENANCY_OCID=${OCI_TENANCY}" >> ~/.oci/.oci_profile
echo "export USER_OCID=${USER_OCID}" >> ~/.oci/.oci_profile
echo "export BUCKET_NS=${BUCKET_NS}" >> ~/.oci/.oci_profile

tar czvf oci_api_key_${NOW}.tar.gz ~/.oci
