# Commander workshop

Example workshop to show data streaming using service interconnect

## Prerequirements

Set environment variables REGISTRY_USERNAME and REGISTRY_PASSWORD if you need to access registry.redhat.io

```
export REGISTRY_USERNAME="myusername"
export REGISTRY_PASSWORD="mypassword"
```

## Start with the Core OpenShift

Login to core OCP

```
oc login --token=sha256~12345 --server=https://api.coreocp.com:6443
```

Enter this directory

```
cd workshops/commander
```

Provision the commander project via ansible

```
ansible-playbook -e project="commander" \
 -e registry_username="$REGISTRY_USERNAME" \
 -e registry_password="$REGISTRY_PASSWORD" \
 -e postgresql_database="commander" \
 -e postgresql_user="commander" \
 -e postgresql_password="commander" playbook_deploy_commander.yml
```

Wait until postgresql database is provisioned and loaded with content and
commander application is provisioned

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

Install the Red Hat Service Interconnect router

```
skupper init -n commander

skupper token create -n commander secret.token
```

## Expose the postgresql database on the service network

```
skupper expose deployment/postgresql --port 5432 -n commander
```

## Switch to remote OpenShift

Login to remote OCP

```
oc login --token=sha256~12345 --server=https://app.remoteocp.com:6443
```

Enter this directory

```
cd workshops/commander
```

Provision the commander-cache project via ansible

```
ansible-playbook -e project="commander-cache" \
 -e registry_username="$REGISTRY_USERNAME" \
 -e registry_password="$REGISTRY_PASSWORD" \
 -e postgresql_database="commander" \
 -e postgresql_user="commander" \
 -e postgresql_password="commander" playbook_deploy_commander_cache.yml
```

Wait until commander-cache is provisioned

## Show commander-cache API

You can inspect the api /member, /equipment and /battalion to show that there is not data available

## Create the service network

Install the Red Hat Service Interconnect router

```
skupper init -n commander-cache

skupper link create -n commander-cache secret.token
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

## Demo completed

The demo is completed!

### Utils

If you need to switch between the two OpenShift, you can do by:

```
oc config view # will return available context

oc config use-context default/api-some-server:6443/kube:admin
```