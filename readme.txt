You'll need to make sure that the user you run this as can ssh to
root@localhost via public key authentication (the setup.sh script checks
for this).

Prior to running any commands you can edit vars.yml to modify the values
for these if you don't want the defaults.  The only one you really must
set is hostname (to the DNS name or IP of the VM you are running this
on), and you can do this on the command line:

$ source setup.sh
$ ansible-playbook -e "hostname=localhost" smart.yml

