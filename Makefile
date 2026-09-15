CLUSTER_NAME   := hestia-local
SUBNET         := 192.168.111.0/24
KUBECONFIG_OUT := hestia-local.kubeconfig
INHIBIT_PID_FILE := /tmp/$(CLUSTER_NAME)-inhibit.pid

# Csak a "kubeconfig" célhoz kell, a SAJAT gepedrol futtatva:
# make kubeconfig T480_HOST=192.168.111.X
T480_HOST ?=
T480_USER ?= i3hunor
T480_REMOTE_PATH ?= ~/Hestia/$(KUBECONFIG_OUT)

LAPTOP_IP := $(shell hostname -I | awk '{print $$1}')

.PHONY: ssh up kubeconfig down status

# 1) FUTTASD A T480-ON: nyitja a 22-es portot a subnetnek
ssh:
	sudo systemctl start sshd.service
	sudo iptables -D INPUT -p tcp --dport 22 -s $(SUBNET) -j ACCEPT 2>/dev/null || true
	sudo iptables -A INPUT -p tcp --dport 22 -s $(SUBNET) -j ACCEPT
	@echo "-> SSH fut, elerheto a $(SUBNET) subnetrol."

# 2) FUTTASD A T480-ON: nyitja a 6443-at, elindul docker + kind cluster
up:
	sudo iptables -D INPUT -p tcp --dport 6443 -s $(SUBNET) -j ACCEPT 2>/dev/null || true
	sudo iptables -A INPUT -p tcp --dport 6443 -s $(SUBNET) -j ACCEPT
	sudo systemctl start docker.service
	@if kind get clusters 2>/dev/null | grep -qx "$(CLUSTER_NAME)"; then \
		echo "-> kind cluster ($(CLUSTER_NAME)) mar letezik, ujrahasznalva."; \
	else \
		tmpconfig=$$(mktemp); \
		printf 'apiVersion: kind.x-k8s.io/v1alpha4\nkind: Cluster\nnetworking:\n  apiServerAddress: "0.0.0.0"\n  apiServerPort: 6443\nkubeadmConfigPatches:\n  - |\n    kind: ClusterConfiguration\n    apiServer:\n      certSANs:\n        - "$(LAPTOP_IP)"\n' > $$tmpconfig; \
		kind create cluster --name $(CLUSTER_NAME) --config $$tmpconfig; \
		rm -f $$tmpconfig; \
		echo "-> kind cluster ($(CLUSTER_NAME)) letrehozva, cert SAN: $(LAPTOP_IP)"; \
	fi
	kind get kubeconfig --name $(CLUSTER_NAME) | sed 's/127.0.0.1/$(LAPTOP_IP)/' > $(KUBECONFIG_OUT)
	@echo "-> Kubeconfig kesz a t480-on: $$(pwd)/$(KUBECONFIG_OUT)"
	@setsid systemd-inhibit --what=handle-lid-switch --who="MakefileToggle" --why="kind cluster fut" sleep infinity & echo $$! > $(INHIBIT_PID_FILE)
	@echo "-> Fedel lecsukas elleni vedelem aktiv."
	@echo "=== KLASZTER FUT, a t480-hoz mostantol nem kell tobbet nyulnod ==="

# 3) FUTTASD A SAJAT GEPEDEN (t14): lehuzza a kubeconfigot a t480-rol
kubeconfig:
	@if [ -z "$(T480_HOST)" ]; then \
		echo "Hiba: add meg a T480_HOST-ot, pl: make kubeconfig T480_HOST=192.168.111.50"; \
		exit 1; \
	fi
	scp $(T480_USER)@$(T480_HOST):$(T480_REMOTE_PATH) ./$(KUBECONFIG_OUT)
	@echo "-> Kubeconfig lehuzva: ./$(KUBECONFIG_OUT)"
	@echo "-> Hasznalat: export KUBECONFIG=$$(pwd)/$(KUBECONFIG_OUT)"

# 4) FUTTASD A T480-ON: mindent torol, visszaallitja az eredeti allapotot
down:
	-kind delete cluster --name $(CLUSTER_NAME)
	-sudo systemctl stop docker.service docker.socket
	-sudo iptables -D INPUT -p tcp --dport 6443 -s $(SUBNET) -j ACCEPT 2>/dev/null
	-sudo iptables -D INPUT -p tcp --dport 22 -s $(SUBNET) -j ACCEPT 2>/dev/null
	-sudo systemctl stop sshd.service
	-@if [ -f $(INHIBIT_PID_FILE) ]; then kill $$(cat $(INHIBIT_PID_FILE)) 2>/dev/null; rm -f $(INHIBIT_PID_FILE); fi
	-rm -f $(KUBECONFIG_OUT)
	@echo "-> Minden torolve, a t480 ugyanugy nez ki, mint indulaskor."

status:
	@kind get clusters 2>/dev/null || echo "Nincs futo kind cluster."
	@systemctl is-active docker.service 2>/dev/null || true
	@systemctl is-active sshd.service 2>/dev/null || true
