#!/bin/bash

sudo apt-get update
sudo apt-get install -y nodejs npm
sudo npm install n -g
n lts
sudo apt-get purge -y nodejs npm
