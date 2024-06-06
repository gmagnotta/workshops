#!/bin/bash

set -eu -o pipefail


#skopeo copy --preserve-digests docker://$HOST/hello-tomcat/hello-tomcat:latest oci-archive:/tmp/hello-tomcat
#skopeo copy --preserve-digests docker://$HOST/hello-tomcat/hello-tomcat:sha256-5cd34d5cc42af5c732a370bdb09b9d13fdc1fb15d4caff8c059c66f146c28988.sig oci-archive:/tmp/hello-tomcat-5cd34d5cc42af5c732a370bdb09b9d13fdc1fb15d4caff8c059c66f146c28988.sig
#skopeo copy --preserve-digests docker://$HOST/hello-tomcat/hello-tomcat:sha256-5cd34d5cc42af5c732a370bdb09b9d13fdc1fb15d4caff8c059c66f146c28988.att oci-archive:/tmp/hello-tomcat-5cd34d5cc42af5c732a370bdb09b9d13fdc1fb15d4caff8c059c66f146c28988.att

#skopeo copy --preserve-digests docker://$HOST/hello-tomcat/hello-tomcat:sbom oci-archive:/tmp/hello-tomcat-sbom
#skopeo copy --preserve-digests docker://$HOST/hello-tomcat/hello-tomcat:sha256-2967f8e4af76f4ad0f54484939c69fe82a1054cd8d2740ca39eca2cff60786f9.sig oci-archive:/tmp/hello-tomcat-sbom-2967f8e4af76f4ad0f54484939c69fe82a1054cd8d2740ca39eca2cff60786f9.sig
#skopeo copy --preserve-digests docker://$HOST/hello-tomcat/hello-tomcat:sha256-2967f8e4af76f4ad0f54484939c69fe82a1054cd8d2740ca39eca2cff60786f9.att oci-archive:/tmp/hello-tomcat-sbom-2967f8e4af76f4ad0f54484939c69fe82a1054cd8d2740ca39eca2cff60786f9.att


skopeo copy --preserve-digests oci-archive:/tmp/hello-tomcat docker://quay.io/gmagnotta/hello-tomcat:latest
skopeo copy --preserve-digests oci-archive:/tmp/hello-tomcat-5cd34d5cc42af5c732a370bdb09b9d13fdc1fb15d4caff8c059c66f146c28988.sig docker://quay.io/gmagnotta/hello-tomcat:sha256-5cd34d5cc42af5c732a370bdb09b9d13fdc1fb15d4caff8c059c66f146c28988.sig 
skopeo copy --preserve-digests oci-archive:/tmp/hello-tomcat-5cd34d5cc42af5c732a370bdb09b9d13fdc1fb15d4caff8c059c66f146c28988.att docker://quay.io/gmagnotta/hello-tomcat:sha256-5cd34d5cc42af5c732a370bdb09b9d13fdc1fb15d4caff8c059c66f146c28988.att 

skopeo copy --preserve-digests oci-archive:/tmp/hello-tomcat-sbom docker://quay.io/gmagnotta/hello-tomcat:sbom 
skopeo copy --preserve-digests oci-archive:/tmp/hello-tomcat-sbom-2967f8e4af76f4ad0f54484939c69fe82a1054cd8d2740ca39eca2cff60786f9.sig docker://quay.io/gmagnotta/hello-tomcat:sha256-2967f8e4af76f4ad0f54484939c69fe82a1054cd8d2740ca39eca2cff60786f9.sig 
skopeo copy --preserve-digests oci-archive:/tmp/hello-tomcat-sbom-2967f8e4af76f4ad0f54484939c69fe82a1054cd8d2740ca39eca2cff60786f9.att docker://quay.io/gmagnotta/hello-tomcat:sha256-2967f8e4af76f4ad0f54484939c69fe82a1054cd8d2740ca39eca2cff60786f9.att 


