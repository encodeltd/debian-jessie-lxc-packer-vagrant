# Disable CDROM entries to prevent apt-get from prompting to insert a disk
sed -i "/^deb cdrom:/s/^/#/" /etc/apt/sources.list

apt-get -y update
apt-get -y upgrade
apt-get -y install curl wget vim emacs-nox bind9utils sudo puppet less man rsyslog
apt-get clean
