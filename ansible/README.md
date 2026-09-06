RUN ON PVE BEFORE STARTING THE PLAYBOOK
qm resize xx scsi0 32G

On the first run you have to connect manually to add the key to the known hosts.
Run the PLAYBOOK

# Improvement opportunites
- Auto reboot after the resize playbook
- Add the PVE node as a node and automate the qm resize too
- Auto add nvim and tmux config to the node
