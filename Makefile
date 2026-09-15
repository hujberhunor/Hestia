CLUSTER_NAME   := hestia-local
SUBNET         := 192.168.111.0/24
KUBECONFIG_OUT := hestia-local.kubeconfig
INHIBIT_PID_FILE := /tmp/$(CLUSTER_NAME)-inhibit.pid

# Only needed for the "kubeconfig" target, run FROM YOUR OWN machine:
# make kubeconfig T480_HOST=192.168.111.X
T480_HOST ?=
T480_USER ?= i3hunor
T480_REMOTE_PATH ?= ~/Hestia/$(KUBECONFIG_OUT)

LAPTOP_IP := $(shell ip -4 -o addr show scope global | awk '{print $$4}' | cut -d/ -f1 | grep '^192\.168\.111\.' | head -n1)

.PHONY: ssh up kubeconfig down status

# 1) RUN ON THE T480: opens port 22 for the subnet
ssh:
	sudo systemctl start sshd.service
	sudo iptables -D INPUT -p tcp --dport 22 -s $(SUBNET) -j ACCEPT 2>/dev/null || true
	sudo iptables -A INPUT -p tcp --dport 22 -s $(SUBNET) -j ACCEPT
	@echo "-> SSH is running, reachable from the $(SUBNET) subnet."

# 2) RUN ON THE T480: opens port 6443, starts docker + kind cluster
up:
	@if [ -z "$(LAPTOP_IP)" ]; then \
		echo "Error: could not automatically detect the 192.168.111.x IP."; \
		echo "Set it manually: make up LAPTOP_IP=192.168.111.X"; \
		exit 1; \
	fi
	sudo iptables -D INPUT -p tcp --dport 6443 -s $(SUBNET) -j ACCEPT 2>/dev/null || true
	sudo iptables -A INPUT -p tcp --dport 6443 -s $(SUBNET) -j ACCEPT
	sudo systemctl start docker.service
	@if kind get clusters 2>/dev/null | grep -qx "$(CLUSTER_NAME)"; then \
		echo "-> kind cluster ($(CLUSTER_NAME)) already exists, reusing it."; \
	else \
		tmpconfig=$$(mktemp); \
		printf 'apiVersion: kind.x-k8s.io/v1alpha4\nkind: Cluster\nnetworking:\n  apiServerAddress: "0.0.0.0"\n  apiServerPort: 6443\nkubeadmConfigPatches:\n  - |\n    kind: ClusterConfiguration\n    apiServer:\n      certSANs:\n        - "$(LAPTOP_IP)"\n' > $$tmpconfig; \
		if ! kind create cluster --name $(CLUSTER_NAME) --config $$tmpconfig; then \
			echo "Error: kind cluster creation failed, cleaning up..."; \
			rm -f $$tmpconfig; \
			kind delete cluster --name $(CLUSTER_NAME) 2>/dev/null; \
			exit 1; \
		fi; \
		rm -f $$tmpconfig; \
		echo "-> kind cluster ($(CLUSTER_NAME)) created, cert SAN: $(LAPTOP_IP)"; \
	fi
	@if ! kind get kubeconfig --name $(CLUSTER_NAME) | sed 's/0.0.0.0/$(LAPTOP_IP)/' > $(KUBECONFIG_OUT); then \
		echo "Error: kubeconfig export failed."; \
		exit 1; \
	fi
	@echo "-> Kubeconfig ready on the t480: $$(pwd)/$(KUBECONFIG_OUT)"
	@setsid systemd-inhibit --what=handle-lid-switch --who="MakefileToggle" --why="kind cluster running" sleep infinity & echo $$! > $(INHIBIT_PID_FILE)
	@echo "-> Lid-close protection active."
	@echo "=== CLUSTER RUNNING, you no longer need to touch the t480 ==="

# 3) RUN ON YOUR OWN MACHINE (t14): pulls the kubeconfig from the t480
kubeconfig:
	@if [ -z "$(T480_HOST)" ]; then \
		echo "Error: set T480_HOST, e.g.: make kubeconfig T480_HOST=192.168.111.50"; \
		exit 1; \
	fi
	scp $(T480_USER)@$(T480_HOST):$(T480_REMOTE_PATH) ./$(KUBECONFIG_OUT)
	@echo "-> Kubeconfig pulled: ./$(KUBECONFIG_OUT)"
	@echo "-> Usage: export KUBECONFIG=$$(pwd)/$(KUBECONFIG_OUT)"

# 4) RUN ON THE T480: deletes everything, restores the original state
down:
	-kind delete cluster --name $(CLUSTER_NAME)
	-sudo systemctl stop docker.service docker.socket
	-sudo iptables -D INPUT -p tcp --dport 6443 -s $(SUBNET) -j ACCEPT 2>/dev/null
	-sudo iptables -D INPUT -p tcp --dport 22 -s $(SUBNET) -j ACCEPT 2>/dev/null
	-sudo systemctl stop sshd.service
	-@if [ -f $(INHIBIT_PID_FILE) ]; then kill $$(cat $(INHIBIT_PID_FILE)) 2>/dev/null; rm -f $(INHIBIT_PID_FILE); fi
	-rm -f $(KUBECONFIG_OUT)
	@echo "-> Everything deleted, the t480 looks the same as at startup."

status:
	@kind get clusters 2>/dev/null || echo "No running kind cluster."
	@systemctl is-active docker.service 2>/dev/null || true
	@systemctl is-active sshd.service 2>/dev/null || true
