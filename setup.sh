#!/bin/bash

if [ "$0" != "-bash" ]
then
  echo "this script must be sourced from a bash shell" >&2
  exit 1
fi

BASENAME="$( basename ${BASH_SOURCE[0]} )"
DIRNAME="$( cd $( dirname ${BASH_SOURCE[0]} ); pwd )"

ANSIBLE_REPO="git://github.com/ansible/ansible.git"
ANSIBLE_HOME="/var/tmp/ansible"

for PKG in \
  git python python-jinja2 python-paramiko python-yaml sudo
do
  if ! dpkg -l $PKG >/dev/null 2>&1
  then
    sudo aptitude install $PKG
    if [ $? -ne 0 ]
    then
      echo "an error occurred while installing package $PKG: $?" >&2
      return 1
    fi
  fi
done

if [ ! -d $ANSIBLE_HOME ]
then
  git clone $ANSIBLE_REPO $ANSIBLE_HOME
  if [ $? -ne 0 ]
  then
    echo "clone of ansible repository failed: $?" >&2
    rm -rf $ANSIBLE_HOME
    return 1
  fi
fi

export MANPATH=$ANSIBLE_HOME/docs/man:$MANPATH

if [ -d "$DIRNAME/library" ]
then
  export ANSIBLE_LIBRARY="$DIRNAME/library:$ANSIBLE_HOME/library"
else
  export ANSIBLE_LIBRARY=$ANSIBLE_HOME/library
fi

export PATH=$ANSIBLE_HOME/bin:$PATH

export PYTHONPATH=$ANSIBLE_HOME/lib:$PYTHONPATH

export ANSIBLE_HOSTS="$DIRNAME/hosts"
