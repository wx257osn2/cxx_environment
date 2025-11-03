#!/bin/bash

set -euo pipefail

apt-get install -y --no-install-recommends wine wine64 winetricks msitools winbind

mkdir -p /opt/fontconf
cat << EOF > /opt/fontconf/dummy.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fontconfig.dtd">
<fontconfig>
  <dir>/usr/share/fonts</dir>
</fontconfig>
EOF
