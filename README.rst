My selfhost playbook roles
==========================

**Warning** this is not final and makes a lot of assumptions based on my
personal preferences.  Use at your own risk.  Don't run roles without reading
them and understanding what they do.

Info
----

Source prerequisites
	ansible

Target prerequisites
	ssh access with a sudoer

Run prerequisites
	Define your inventory file in ``inventory``
	Define your playbook in ``book.yml``

How to run
	./deploy.sh

Roles
	TBD

Example playbook
----------------


.. code-block:: ini

	[all]
	zuul
	vinzclortho

	[backup_server]
	vinzclortho

	[dns_server]
	zuul

	[mail_server]
	zuul

	[munin_master]
	zuul

	[nextcloud_server]
	zuul

	[print_server]
	vinzclortho

	[ttrss_server]
	zuul

	[znc_server]
	zuul

.. code-block:: yaml

	---

	# Must be before common - Gathers facts from munin master host for use by munin nodes
	- name: Gather facts for munin master
	  hosts: munin_master
	  tasks:
	  - debug: msg="OK"

	# Must be before common - Creates a backup user that other hosts copy a ssh pubkey to
	- name: Backup Server
	  hosts: backup_server
	  roles:
	    - backup

	- name: Common
	  hosts: all
	  roles:
	    - common
	    - munin-node

	- name: DNS Server (dnsmasq)
	  hosts: dns_server
	  roles:
	    - dnsmasq

	- name: Mail Server (dovecot, postfix)
	  hosts: mail_server
	  roles:
	    - mailserver

	- name: NextCloud Server
	  hosts: nextcloud_server
	  roles:
	    - nextcloud

	- name: Print server
	  hosts: print_server
	  roles:
	    - printserver

	- name: TT-RSS Server
	  hosts: ttrss_server
	  roles:
	    - ttrss

	- name: ZNC Server
	  hosts: znc_server
	  roles:
	    - znc

	- name: Munin master
	  hosts: munin_master
	  roles:
	    - munin-master
