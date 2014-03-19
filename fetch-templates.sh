#!/bin/bash

dir=${1-templates/config}

# Download configuration templates for SMART Servers
mkdir $dir
echo Downloading Configuration Templates for SMART Reference Container
wget -nv https://raw.github.com/chb/smart_server/master/settings.py.default -O $dir/api_settings.py
wget -nv https://raw.github.com/chb/smart_server/master/bootstrap_helpers/application_list.json.default -O $dir/application_list.json
wget -nv https://raw.github.com/chb/smart_server/master/bootstrap_helpers/bootstrap_applications.py.default -O $dir/bootstrap_applications.py
wget -nv https://raw.github.com/chb/smart_ui_server/master/settings.py.default -O $dir/ui_settings.py
wget -nv https://raw.github.com/chb/smart_sample_apps/master/settings.py.default -O $dir/apps_settings.py