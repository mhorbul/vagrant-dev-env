#http://chrisadams.me.uk/2010/05/10/setting-up-a-centos-base-box-for-development-and-testing-with-vagrant/
#kernel source is needed for vbox additions

rpm -Uvh --force --nosignature --nodigest http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -Uvh --force --nosignature --nodigest http://download.elff.bravenet.com/5/i386/elff-release-5-3.noarch.rpm

yum install -y bash curl ftp rsync sudo time wget which git
yum install -y gcc bzip2 make kernel-devel-`uname -r`
yum install -y gcc-c++ patch readline-devel zlib-devel libyaml-devel libffi-devel openssl-devel iconv-devel

yum erase -y wireless-tools gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts

yum -y clean all

cd /tmp
curl -L http://rvm.beginrescueend.com/install/rvm -o rvm-install
bash rvm-install
rm -rf rvm-install
source '/usr/local/rvm/scripts/rvm'
rvm get latest

rvm use 1.9.2 --install --default
rvm default exec gem install chef --no-ri --no-rdoc
rvm default exec gem install puppet --no-ri --no-rdoc

#Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
curl -L http://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub -o authorized_keys
chmod 400 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

exit





