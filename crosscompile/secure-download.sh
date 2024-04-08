#!/bin/bash

set -eu -o pipefail

oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge

HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')

podman login -u $(oc whoami) -p $(oc whoami -t) --tls-verify=false $HOST

skopeo copy --preserve-digests docker://$HOST/crosscompile/crosscompiled:latest oci-archive:/tmp/crosscompiled.img

# transfer the image to the destination and then:

# skopeo copy oci-archive:/tmp/crosscompiled.img containers-storage:localhost/server
# podman  run --rm -ti -p 8081:8000 localhost/server /bin/server