# oci-config-gen

Purpose: A simple helper script to create a set of credentials to be used with the OCI SDK.

Background: There is a requirement to setup up client credentials to use the OCI SDK on a machine external to Oracle Cloud Infrastructure. (https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm)

Content: There is a simple script that can be called in from within the Oracle Cloud Console - Cloud Shell (https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cloudshellintro.htm)

Output:
- An OCI SDK config file and a private / public key pair used for the API Key.
- A profile script that has a select set of environment variables (Tenancy OCID, User OCID, Fingerprint, Bucket Namespace)
- The current user with the API Key uploaded.
- A tar.gz file in the ~/.oci directory with the contents that can be downloaded from the Cloud Shell.

Execute:

To create the profile (and the API Key)
```
$ git clone https://github.com/jlowe000/oci-config-gen
$ cd oci-config-gen
$ chmod 755 user-api-key.sh
$ . ./user-api-key.sh
```

To delete the API Key
```
$ . ~/.oci/.oci_profile
$ oci iam user api-key delete --user-id $USER_OCID --fingerprint $FINGERPRINT --force
```
