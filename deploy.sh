#!/bin/sh
set -xe
ansible-playbook -v --inventory inventory book.yml
