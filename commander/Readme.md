# Commander workshop

Example workshop to show data streaming using service interconnect

## Prerequirements

Install the list of dependencies:

```
ansible-galaxy collection install -r collections/requirements.yml -p collections --force
```

Copy the roles in the roles/ directory.

Configure variables*.yml files

## Start with the Core OpenShift

Enter this directory

```
cd workshops/commander
```

Provision the commander project via ansible navigator

```
ansible-navigator run -m stdout playbook_deploy_commander.yml
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

Service Interconnect is installed automatically by the playbook. A temporary token is generated in
the file secret.token.

PostgreSQL database is automatically exposed on the service network.

In case you need to generate a new token use ansible script:

```
ansible-navigator run -m stdout playbook_skupper_regenerate_token.yml
```

## Provision remote application

Enter this directory

```
cd workshops/commander
```

Provision the commander project via ansible

```
ansible-navigator run -m stdout playbook_deploy_commander_remote.yml
```

Wait until commander is provisioned

## Show commander-cache API

You can inspect the api /member, /equipment and /battalion to show that there is not data available

## Create the service network

The installation of Service Interconnect is delayed until you press the ENTER key.

In case you have troubles (the token is expired) you can regenerate a new token as before and then 

```
ansible-navigator run -m stdout playbook_skupper_removelink_remote.yml
ansible-navigator run -m stdout playbook_skupper_createlink_remote.yml
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