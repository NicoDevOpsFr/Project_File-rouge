#!/bin/bash

ansible-playbook -i host.ini stopped.yml
ansible-playbook -i host.ini started.yml