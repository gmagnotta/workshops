## Hello JBoss Pipeline!

Example project to demonstrate how to migrate a legacy monolith JavaEE
application in containers adopting DevOps practices.

---
How to try:

First, be sure that OpenShift Pipelines is installed in the cluster.

If not already available, deploy SSO and then create a realm for this JavaEE application.

Create a new project and import needed secrets to access registry.redhat.io

If not already available, deploy a PostgreSQL database and then create an user and a database dedicated to this JavaEE application
If not already available, deploy an AMQ Broker and then create an user dedicated to this JavaEE application

Import Custom Tekton S2I Task https://raw.githubusercontent.com/gmagnotta/buildah_s2i/main/buildah_s2i_task.yaml in newly created project.
Import Custom SBOM generate Task https://raw.githubusercontent.com/gmagnotta/container-utils/main/tekton/generate_sbom_task.yaml in newly created project.
Import Custom vulnerability scan Task https://raw.githubusercontent.com/gmagnotta/container-utils/main/tekton/vulnerability_sbom_task.yaml in newly created project.

Customize the variables in playbook_hello-jboss_pipeline.yaml to reflect the environment (username, passwords, urls, etc) 

Run ansible playbook playbook_hello-jboss_pipeline.yaml

Enjoy the automation!

---
To setup webhooks, Github should be configured as:

payload url: 'http://el-listener-<project>.<OCP_DOMAIN>'

content type: application/json

secret: <secret_defined_in_webhook_password>

---
SSO Configuration

Create a realm for this workshop and then create a client dedicated to this JavaEE application.

The client must be of type 'openid-connect' and have 'confidential' access type. (Lastest Keycloak versions map this to the 'Client authentication' setting).
You need to take note of the Client Secret (under Credentials tab) assigned to this application and use in the sso_secret variable
