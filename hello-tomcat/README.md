## Hello Tomcat!

Example project to show how to build and deploy a Tekton Pipeline to build and
deploy the application https://github.com/gmagnotta/examples/tree/master/hello-tomcat

---
How to use:

Create a new project and create needed secrets to access registry.redhat.io
(see https://github.com/gmagnotta/examples/blob/master/infra-components/playbook_initialize_project.yaml)

Import Tekton S2I Task https://github.com/gmagnotta/buildah_s2i/blob/main/buildah_s2i_task.yaml in created project

Run ansible playbook playbook_hello-tomcat_pipeline.yaml

The results is a Tekton Pipeline that exposes an event listner for webhooks.

---

To setup webhooks, Github should be configured as:

payload url: 'http://el-listener-<project>.<OCP_DOMAIN>'

content type: application/json

secret: <secret_defined_in_webhook_password>
