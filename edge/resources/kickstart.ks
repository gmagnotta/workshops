lang en_US.UTF-8
keyboard us
timezone UTC

# ignoredisk --only-use=vda
zerombr
clearpart --all --initlabel
part /boot --fstype=xfs --asprimary --size=800
part /boot/efi --fstype=efi --size=200
part pv.01 --grow --fstype="lvmpv" --size=12294
volgroup rhel pv.01
logvol swap --fstype="swap" --size=2047 --name=swap --vgname=rhel
logvol / --vgname=rhel --fstype=xfs --size=10000 --name=root

reboot
text

network --bootproto=dhcp --ipv6=auto --activate
network  --hostname=localhost.localdomain

%addon com_redhat_kdump --enable --reserve-mb='auto'

ostreesetup --osname="rhel" --remote="rhel" --url="file:///run/install/repo/ostree/repo" --ref="rhel/8/x86_64/edge" --nogpg

%packages
kexec-tools

%end

%post
# Add the pull secret to CRI-O and set root user-only read/write permissions
cat > /etc/crio/openshift-pull-secret << EOF2
<YOUR_PULL_SECRET>
EOF2
chmod 600 /etc/crio/openshift-pull-secret
%end
%post
# Configure the firewall with the mandatory rules for MicroShift
firewall-offline-cmd --zone=trusted --add-source=10.42.0.0/16
firewall-offline-cmd --zone=trusted --add-source=169.254.169.1
%end
