date > /etc/vagrant_box_build_time

if ! id -u vagrant >/dev/null 2>&1; then
    # Vagrant user
    /usr/sbin/groupadd vagrant
    /usr/sbin/useradd vagrant -g vagrant -G sudo -d /home/vagrant -s /bin/bash --create-home
    echo "vagrant:vagrant" | chpasswd
    echo "root:vagrant" | chpasswd
fi

# Set up sudo.  Be careful to set permission BEFORE copying file to sudoers.d
( cat <<'EOP'
%vagrant ALL=NOPASSWD:ALL
EOP
) > /tmp/vagrant
chmod 0440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/

# Install vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

#fix stuff
sed -i '/UsePAM/aUseDNS no' /etc/ssh/sshd_config
sed -i '/env_reset/aDefaults        env_keep += "SSH_AUTH_SOCK"' /etc/sudoers;
#sed -i '/exit/i\/usr\/bin\/apt-get update' /etc/rc.local;
adduser vagrant adm
