#!/bin/bash

if [ "$0" != "-bash" -a "$0" != "-/bin/bash" ]
then
  echo "this script must be sourced from a bash shell" >&2
  exit 1
fi

if ! grep -qi '^ubuntu 12.04' /etc/issue.net
then
  echo "this script must be run on an Ubuntu 12.04 system" >&2
  return 1
fi

BASENAME="$( basename ${BASH_SOURCE[0]} )"
DIRNAME="$( cd $( dirname ${BASH_SOURCE[0]} ); pwd )"

ANSIBLE_REPO="git://github.com/ansible/ansible.git"
ANSIBLE_HOME="/var/tmp/ansible"
ANSIBLE_VERSION_TAG="v1.3.2"

for PKG in \
  git python python-jinja2 python-paramiko python-yaml sudo
do
  if ! dpkg -l $PKG >/dev/null 2>&1
  then
    sudo aptitude -y install $PKG
    if [ $? -ne 0 ]
    then
      echo "an error occurred while installing package $PKG: $?" >&2
      return 1
    fi
  fi
done

sudo -k
sudo -n /bin/true 2>/dev/null
RC=$?
if [ $RC -ne 0 ]
then
  echo "password-less sudo is not enabled: $RC" >&2
  return 1
fi

if [ ! -d $ANSIBLE_HOME ]
then
  git clone $ANSIBLE_REPO $ANSIBLE_HOME
  cd $ANSIBLE_HOME
  git checkout $ANSIBLE_VERSION_TAG
  
  if [ $? -ne 0 ]
  then
    echo "clone of ansible repository failed: $?" >&2
    rm -rf $ANSIBLE_HOME
    return 1
  fi
fi

if ! echo $MANPATH | grep -q "$ANSIBLE_HOME/docs/man"
then
  export MANPATH=$ANSIBLE_HOME/docs/man:$MANPATH
fi

if [ -d "$DIRNAME/library" ]
then
  export ANSIBLE_LIBRARY="$DIRNAME/library:$ANSIBLE_HOME/library"
else
  export ANSIBLE_LIBRARY=$ANSIBLE_HOME/library
fi

if ! echo $PATH | grep -q "$ANSIBLE_HOME/bin"
then
  export PATH=$ANSIBLE_HOME/bin:$PATH
fi

if ! echo $PYTHONPATH | grep -q "$ANSIBLE_HOME/lib"
then
  export PYTHONPATH=$ANSIBLE_HOME/lib:$PYTHONPATH
fi

export ANSIBLE_HOSTS="$DIRNAME/hosts"
