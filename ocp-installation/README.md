# OpenShift Container Platform Installation

## This repository is intended to show how is possible to install OpenShift Container Platform on a cloud provider in automatic way.

## Download openshift-intaller binary

Download openshift installer from https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-install-linux.tar.gz and extract its content. Copy the openshift-install binary to a location that can be referenced later.

## Create installation directory

Create a directory that will store the artifacts from the installation:

`mkdir ~/myinstall`

## Prepare authentication files

If using aws, create the file ~/.aws/credentials with the following content:

`
[default]
aws_access_key_id = <youraccesskeyid> 
aws_secret_access_key = <yoursecretaccesskey>
`

If using azure, create the file ~/.azure/osServicePrincipal.json with the following content:

`
{"subscriptionId":"<yoursubscriptionid>","clientId":"<yourclientid>","clientSecret":"<yourclientsecret>","tenantId":"<yourtenantid>"}
`

## Customize the install-config.yaml

Copy the proper install-config.yaml from aws or azure directory to the installation directory created at the previous stage, accordingly to the target cloud.

Remember to change the values in '<>'

## Run the installation

Use openshift-install binary to create the cluster:

`
openshift-install create cluster --dir <directory> --log-level=info
`

## Delete the cluster

In case you want to delete the cluster you can use openshift-install binary and the directory containing installation artifacts:

`
openshift-install destroy cluster --dir <directory> --log-level=info

`
