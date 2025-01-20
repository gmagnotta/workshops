# Commander workshop

Example workshop to show data streaming using service interconnect

## Prerequirements

Install the list of dependencies:

```
ansible-galaxy collection install -r collections/requirements.yml -p collections --force
```

Set these environment variables:

```
export REGISTRY_USERNAME="myusername" # for registry.redhat.io
export REGISTRY_PASSWORD="mypassword"
export OCP_URL="https://api.mycluster.openshiftapps.com:6443"
export OCP_USERNAME="myocpuser"
export OCP_PASSWORD="myocppassword"
```

Copy the roles in the roles/ directory.

## Start with the Core OpenShift

Enter this directory

```
cd workshops/commander
```

Provision the commander project via ansible navigator

```
ansible-navigator run --senv PROJECT="commander" \
 --senv REGISTRY_USERNAME="$REGISTRY_USERNAME" \
 --senv REGISTRY_PASSWORD="$REGISTRY_PASSWORD" \
 --senv OCP_URL="$OCP_URL" \
 --senv OCP_USERNAME="$OCP_USERNAME" \
 --senv OCP_PASSWORD="$OCP_PASSWORD" \
 -m stdout playbook_deploy_commander.yml
```

Wait until everything is deployed.

## Show commander API

You can inspect the api /member, /equipment and /battalion to show the content
read from the database

## Create a new member via API call

You can create new members in the database with curl

```
curl -v --header "Content-Type: application/json" \
  --request POST \
  --data '{"email":"soldier1@email.com","name":"Soldier1", "rank":"soldier", "battalion": 1}' \
  http://commander-commander.apps.cluster.com/member/1
```

## Create the service network

Service Interconnect is installed automatically by the playbook. In case you need to manage
it manually:

```
skupper init -n commander

skupper token create -n commander secret.token
```

## Expose the postgresql database on the service network

```
skupper expose deployment/postgresql --port 5432 -n commander
```

## Switch to remote OpenShift

Enter this directory

```
cd workshops/commander
```

Provision the commander project via ansible

```
ansible-navigator run --senv PROJECT="commander-cache" \
 --senv REGISTRY_USERNAME="$REGISTRY_USERNAME" \
 --senv REGISTRY_PASSWORD="$REGISTRY_PASSWORD" \
 --senv OCP_URL="$OCP_URL" \
 --senv OCP_USERNAME="$OCP_USERNAME" \
 --senv OCP_PASSWORD="$OCP_PASSWORD" \
 -m stdout playbook_deploy_commander_remote.yml
```

Wait until commander is provisioned

## Show commander-cache API

You can inspect the api /member, /equipment and /battalion to show that there is not data available

## Create the service network

Service Interconnect is installed automatically by the playbook. In case you need to manage
it manually:

```
skupper init -n commander

skupper link create -n commander secret.token
```

Now the remote postgresql database should be accessinble to debezium.
If the pod is still in error, you can force a restart manually by deleting it.

Show the debezium logs that will start stream database content

## Show commander-cache API

You can inspect the api /member, /equipment and /battalion to show that the data
is automatically synchronized

## Create a new member via API call

You can create new members in the database with curl

```
curl -v --header "Content-Type: application/json" \
  --request POST \
  --data '{"email":"soldier1@email.com","name":"Soldier1", "rank":"soldier", "battalion": 1}' \
  http://commander-commander.apps.cluster.com/member/1
```

As soon as debezium intercept the transaction, the data is streamed to commander-cache

## Edge device

You can perform the same demo also on an edge device running microshift. Just use the playbook_deploy_commander_edge.yml playbook.

## Demo completed

The demo is completed!

### Utils

If you need to switch between the two OpenShift, you can do by:

```
oc config view # will return available context

oc config use-context default/api-some-server:6443/kube:admin
```