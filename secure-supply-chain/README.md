# Secure Supply Chain

## This repository is intended as a placeholder for collecting useful resources to demonstrate on how to build a secure supply chain.

## Prerequirements

Install the list of dependencies:

```
ansible-galaxy collection install -r collections/requirements.yml -p collections --force
```

Configure variables*.yml files

## How to start

Run the ansible playbook 'playbook_tekton_chains.yaml'

After Tekton Chains is installed, it will monitors TaskRun providing results [IMAGE_URL] and [IMAGE_DIGEST].

When the results are found, it will use cosign to automatically generate the signature of the image and the attestation.

The registry will provide 2 new tags: [.att] the attestation and [.sig] the signature.

## Download

To manually download images, signature and attestation from an Image registry to local filesystem
`skopeo copy --preserve-digests docker://image-registry.localdomain/project/image:version oci-archive:/tmp/myimage`
`skopeo copy --preserve-digests docker://image-registry.localdomain/project/image:sha256-myhash.sig oci-archive:/tmp/myimage-myhash.sig`
`skopeo copy --preserve-digests docker://image-registry.localdomain/project/image:sha256-myhash.att oci-archive:/tmp/myimage-myhash.att`

## Upload

To manually upload images, signature and attestation from local filesystem to an Image registry
`skopeo copy --preserve-digests oci-archive:/tmp/myimage docker://image-registry.localdomain/project/image:mytag`
`skopeo copy --preserve-digests oci-archive:/tmp/myimage-myhash.sig docker://image-registry.localdomain/project/image:sha256-myhash.sig`
`skopeo copy --preserve-digests oci-archive:/tmp/myimage-myhash.att docker://image-registry.localdomain/project/image:sha256-myhash.att`

## Verify Signature and Attestation

To verify the signature and image attestation, you need to download the public key used by cosign to sign and save it locally as cosign.pub.

`cosign verify --key cosign.pub image-registry.localdomain/project/image:mytag`
`cosign verify-attestation --key cosign.pub --type slsaprovenance image-registry.localdomain/project/image:mytag`

## Verify Attestation on the public rekor service

To verify the attestation on the public rekor service, visit https://search.sigstore.dev/ select 'Hash', and insert the the sha256 hash of the image 

## Inspect a container's filesystem

`podman unshare`

`podman image mount <myimage>`

## Reference

https://docs.openshift.com/container-platform/4.13/cicd/pipelines/using-tekton-chains-for-openshift-pipelines-supply-chain-security.html#signing-secrets-in-tekton-chains_using-tekton-chains-for-openshift-pipelines-supply-chain-security
