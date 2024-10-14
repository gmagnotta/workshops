## Commander DEMO

ansible-playbook -e project="commander" -e registry_username="user" \
 -e registry_password="password" -e postgresql_database="commander" \
 -e postgresql_user="commander" -e postgresql_password="commander" \
 playbook_deploy_commander.yml