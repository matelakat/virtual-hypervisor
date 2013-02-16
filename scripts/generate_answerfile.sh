#!/bin/bash

set -eu

function print_usage_and_quit
{
cat << USAGE >&2
usage: $(basename $0) NETWORK_CONFIG [options]

Create an answerfile for automated install

Positional arguments:
 NETWORK_CONFIG         network configuration: dhcp or static

optional arguments:
 -h     hostname 
 -i     ip address
 -m     netmask
 -g     gateway
 -p     password for the new system DEFAULT: somepass
 -n     nameserver
USAGE
exit 1
}

NETWORK_CONFIG="${1-$(print_usage_and_quit)}"

case $NETWORK_CONFIG in
 dhcp)
  ;;
 static)
  ;;
 *)
  echo "Invalid network configuration: $NETWORK_CONFIG" >&2
  print_usage_and_quit
  ;;
esac

shift

HOSTNAME=""
IP=""
NETMASK=""
GATEWAY=""
PASSWORD="somepass"
NAMESERVER=""

while getopts ":h:i:m:g:p:n:" opt; do
  case $opt in
    h)
      HOSTNAME="$OPTARG"
      ;;
    i)
      IP="$OPTARG"
      ;;
    m)
      NETMASK="$OPTARG"
      ;;
    g)
      GATEWAY="$OPTARG"
      ;;
    p)
      PASSWORD="$OPTARG"
      ;;
    n)
      NAMESERVER="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      print_usage_and_quit
      ;;
  esac
done

cat << EOF
<?xml version="1.0"?>
<installation srtype="ext">
<primary-disk>sda</primary-disk>
<keymap>us</keymap>
<root-password>$PASSWORD</root-password>
<source type="local"></source>
EOF

if [ "static" = "$NETWORK_CONFIG" ]
then
cat << EOF
<admin-interface name="eth0" proto="static">
<ip>$IP</ip>
<subnet-mask>$NETMASK</subnet-mask>
<gateway>$GATEWAY</gateway>
</admin-interface>
EOF
else
cat << EOF
<admin-interface name="eth0" proto="dhcp" />
EOF
fi

cat << EOF
<timezone>America/Los_Angeles</timezone>
<script stage="filesystem-populated" type="url">file:///postinst.sh</script>
EOF

if [ ! -z "$HOSTNAME" ]
then
cat << EOF
<hostname>$HOSTNAME</hostname>
EOF
fi

if [ ! -z "$NAMESERVER" ]
then
cat << EOF
<nameserver>$NAMESERVER</nameserver>
EOF
fi

cat << EOF
</installation>
EOF
