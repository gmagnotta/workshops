Demo to build rhel for edge custom images

Sources:

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/composing_installing_and_managing_rhel_for_edge_images/creating-and-managing-ostree-image-updates_composing-installing-managing-rhel-for-edge-images#creating-ostree-repositories_creating-and-managing-ostree-image-updates

http://osbuild.org


Prereqs

1 - install nginx
2 - install `sudo dnf install osbuild-composer composer-cli && sudo systemctl enable --now osbuild-composer.socket`
3 - add container registry credentials
4 - add optional repositories


Step 0:

# Build minimal blueprint
composer-cli blueprints push demo93-minimal.toml

# Create edge commit
composer-cli compose start-ostree demo93-minimal edge-commit

# Check status
composer-cli compose status

# Download tarball of edge-commit
composer-cli compose image _<uuid>

# Extract content to http nginx server
tar -xf <uuid>.tar -C /usr/share/nginx/html/

# optional inspect repo content
ostree --repo=/usr/share/nginx/html/repo refs
ostree --repo=/usr/share/nginx/html/repo log rhel/9/x86_64/edge # Extract commit id

# Import minimal installer blueprint
composer-cli blueprints push demo93-minimal-installer.toml

# Create installer
composer-cli compose start-ostree demo93-minimal-installer edge-installer --ref rhel/9/x86_64/edge --url http://localhost/repo

# or in alternative create minimal raw disk
composer-cli compose start-ostree demo93-minimal-installer minimal-raw --ref rhel/9/x86_64/edge --url http://localhost/repo

# Download image
composer-cli compose image _<uuid>


Step 1:

# Import customized blueprint with new content
composer-cli blueprints push demo93-tomcat.toml

# Build edge commit
composer-cli compose start-ostree demo93-tomcat edge-commit --ref rhel/9/x86_64/edge --url http://localhost/repo

# Downlod new tarball
composer-cli compose image <netuuid>

# Extract content
tar -xf <newuuid>.tar

# Pull the commit to the repo
ostree --repo=/usr/share/nginx/html/repo pull-local repo

# optional Inspect ostree repo
ostree --repo=/usr/share/nginx/html/repo refs
ostree --repo=/usr/share/nginx/html/repo show rhel/9/x86_64/edge
ostree --repo=/usr/share/nginx/html/repo log rhel/9/x86_64/edge
rpm-ostree db diff --repo=/usr/share/nginx/html/repo 89290dbfd6f749700c77cbc434c121432defb0c1c367532368eee170d9e53ea9 a35c3b1a9e731622f32396bb1aa84c73b16bd9b9b423e09d72efaca11b0411c9


Step 2:

Copy updated edge-commit to remote edge device

# extract edge-commit
tar -xf <uuuid>.tar

# Create temporary ostree local repo
mkdir -p /run/install/repo/ostree

ln -s /tmp/repo /run/install/repo/ostree/repo

# Run upgrade check and upgrade
rpm-ostree upgrade --check
rpm-ostree upgrade

rpm-ostree status

systemctl reboot

---------------

# Other info. In case you merge a commit in the master repo in nginx, you can build new commit or installer refererring explictly to which parent with --parent <commitid>

# Download image

composer-cli compose image <uuid>

xz -d file.raw.img.xz

# Microshift
import pull secret in /etc/crio/openshift-pull-secret
