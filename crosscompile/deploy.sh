#!/bin/sh

export CONTAINER_UTILS="/home/gmagnott/src/container-utils"

export PROJECT="crosscompile"
#export REGISTRY_USERNAME="user"
#export REGISTRY_PASSWORD="password"

set -e

ansible-playbook -e project=$PROJECT -e registry_username=$REGISTRY_USERNAME \
 -e registry_password=$REGISTRY_PASSWORD \
 $CONTAINER_UTILS/playbooks/playbook_initialize_project.yaml

ansible-playbook -e project=$PROJECT playbook_crosscompile_pipeline.yaml
