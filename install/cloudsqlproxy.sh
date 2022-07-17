#!/bin/bash

INSTALL_LOCATION=~/.local/bin

wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O $INSTALL_LOCATION/cloud_sql_proxy
chmod +x $INSTALL_LOCATION/cloud_sql_proxy
