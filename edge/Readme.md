Demo to build rhel for edge custom images

Sources:

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/composing_installing_and_managing_rhel_for_edge_images/creating-and-managing-ostree-image-updates_composing-installing-managing-rhel-for-edge-images#creating-ostree-repositories_creating-and-managing-ostree-image-updates

http://osbuild.org

https://shonpaz.medium.com/zero-touch-provisioning-of-edge-devices-using-microshift-and-rhel-for-edge-e122836fa888

https://github.com/osbuild/rhel-for-edge-demo/


Prereqs

1 - install nginx
2 - install `sudo dnf install osbuild-composer composer-cli && sudo systemctl enable --now osbuild-composer.socket`
3 - add container registry credentials
4 - add optional repositories

Step 0 - Create local repository for rpms

# Install createrepo
sudo yum install createrepo

# Create dest dir
mkdir /opt/rpms

# Copy required artifacts
put rpms in /opt/rpms directory

# Create repository metadata
createrepo /opt/rpms

# Or, if you already created metadata, just update it
createrepo --update /opt/rpms

# Copy repository to nginx irectory /usr/share/nginx/html/RPMS

# add local source
composer-cli sources add repo-local-rpmbuild.toml


Step 1 - Build initial ostree:

# Build minimal blueprint
composer-cli blueprints push demo93-minimal.toml

# Verify rpms content
composer-cli blueprints depsolve demo93-minimal

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
rpm-ostree db list rhel/9/x86_64/edge --repo=/usr/share/nginx/html/repo

# Import minimal installer blueprint
composer-cli blueprints push demo93-minimal-installer.toml

# Create installer
composer-cli compose start-ostree demo93-minimal-installer edge-installer --ref rhel/9/x86_64/edge --url http://localhost/repo

# or in alternative create minimal raw disk image
composer-cli compose start-ostree demo93-minimal-installer minimal-raw --ref rhel/9/x86_64/edge --url http://localhost/repo

# Download resulting image and install
composer-cli compose image _<uuid>


Step 2 - Create updated ostree:

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


Step 3 - Copy updated edge-commit to remote edge device

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


# convert qcow2 to img
qemu-img convert -O raw -f qcow2 image.qcow2 image-raw.img

# Embed kickstart in iso file
mkksiso kickstart.ks 9509b4de-dc66-4020-9d24-86476ffe086f-installer.iso microshift-rpmostree-installer.iso