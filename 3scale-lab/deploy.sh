#!/bin/sh

export CONTAINER_UTILS="/home/gmagnott/src/container-utils"

export PROJECT="3scale"
#export REGISTRY_USERNAME="user"
#export REGISTRY_PASSWORD="password"
export SSO_SERVER="sso.apps.cluster-hq9vh.dynamic.redhatworkshops.io"
export WILDCARD_DOMAIN="apps.cluster-hq9vh.dynamic.redhatworkshops.io"

set -e

ansible-playbook -e project=$PROJECT -e registry_username=$REGISTRY_USERNAME \
 -e registry_password=$REGISTRY_PASSWORD \
 $CONTAINER_UTILS/playbooks/playbook_initialize_project.yaml

ansible-playbook -e project=$PROJECT \
 -e wildcard_domain=$WILDCARD_DOMAIN \
 -e sso_server=$SSO_SERVER \
 playbook_3scale.yaml
