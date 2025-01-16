#!/bin/bash


ansible all -m package -a "name=httpd state=installed"

ansible all -m service -a "name=httpd state=started enabled=yes"


