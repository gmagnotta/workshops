# Exampe kickstart for RHEL 8

lang en_US.UTF-8
keyboard us
timezone UTC

zerombr
clearpart --all --initlabel
part /boot --fstype=xfs --asprimary --size=800
part /boot/efi --fstype=efi --size=200
part pv.01 --grow --fstype="lvmpv"
volgroup rhel pv.01
logvol swap --fstype="swap" --size=2047 --name=swap --vgname=rhel
logvol / --vgname=rhel --fstype=xfs --size=10000 --name=root

reboot
text

network --bootproto=dhcp --ipv6=auto --activate --hostname=localhost.localdomain

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

ostreesetup --osname="rhel" --remote="rhel" --url="file:///run/install/repo/ostree/repo" --ref="rhel/8/x86_64/edge" --nogpg

%packages
kexec-tools

%end

%post

# Create custom files
cat > /etc/myfile << EOF2
Hello world!
EOF2
chmod 600 /etc/myfile

%end

%post
# Configure the firewall with the mandatory rules for MicroShift
firewall-offline-cmd --zone=trusted --add-source=10.42.0.0/16
firewall-offline-cmd --zone=trusted --add-source=169.254.169.1
%end
