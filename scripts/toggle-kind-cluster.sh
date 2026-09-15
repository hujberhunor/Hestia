#!/usr/bin/env bash

CLUSTER_NAME="hestia-local"
SUBNET="192.168.111.0/24"

# Kilépéskor automatikusan lefutó helyreállító függvény (SIGINT, SIGTERM vagy normál exit esetén)
cleanup() {
    echo -e "\n[+] Leállítás: Visszaállítás az eredeti állapotra..."

    # 1. kind cluster törlése
    kind delete cluster --name "$CLUSTER_NAME" 2>/dev/null
    echo "  -> kind cluster ($CLUSTER_NAME) törölve."

    # 2. Docker daemon leállítása
    sudo systemctl stop docker.service docker.socket
    echo "  -> Docker daemon leállítva."

    # 3. Tűzfal szabályok törlése (SSH + kube API) és SSH leállítása
    sudo iptables -D INPUT -p tcp --dport 22 -s "$SUBNET" -j ACCEPT 2>/dev/null
    sudo iptables -D INPUT -p tcp --dport 6443 -s "$SUBNET" -j ACCEPT 2>/dev/null
    sudo systemctl stop sshd.service
    echo "  -> SSH szerver leállítva, tűzfalszabályok törölve (22, 6443)."

    # 4. Inhibit folyamat leállítása
    if [ -n "$INHIBIT_PID" ]; then
        kill "$INHIBIT_PID" 2>/dev/null
        echo "  -> Fedél lecsukás elleni védelem kikapcsolva."
    fi

    echo "[+] Rendszer visszaállítva!"
    exit 0
}

# Trap beállítása a szignálokra
trap cleanup INT TERM EXIT

echo "[+] Mód bekapcsolása..."

# 1. SSH engedélyezése csak a helyi alhálózatról
sudo systemctl start sshd.service
sudo iptables -D INPUT -p tcp --dport 22 -s "$SUBNET" -j ACCEPT 2>/dev/null
sudo iptables -A INPUT -p tcp --dport 22 -s "$SUBNET" -j ACCEPT
echo "  -> SSH fut és elérhető a $SUBNET subnetből."

# 2. Kubernetes API port (6443) engedélyezése csak a helyi alhálózatról
sudo iptables -D INPUT -p tcp --dport 6443 -s "$SUBNET" -j ACCEPT 2>/dev/null
sudo iptables -A INPUT -p tcp --dport 6443 -s "$SUBNET" -j ACCEPT
echo "  -> Kubernetes API port (6443) elérhető a $SUBNET subnetből."

# 3. Docker daemon elindítása
sudo systemctl start docker.service
echo "  -> Docker daemon elindítva."

# 4. kind cluster létrehozása (vagy újrahasznosítása, ha már létezik), nyitott API bindinggel
if kind get clusters 2>/dev/null | grep -qx "$CLUSTER_NAME"; then
    echo "  -> kind cluster ($CLUSTER_NAME) már létezik, újrahasználva."
else
    KIND_CONFIG=$(mktemp)
    cat > "$KIND_CONFIG" << EOF
apiVersion: kind.x-k8s.io/v1alpha4
kind: Cluster
networking:
  apiServerAddress: "0.0.0.0"
  apiServerPort: 6443
EOF
    kind create cluster --name "$CLUSTER_NAME" --config "$KIND_CONFIG"
    rm -f "$KIND_CONFIG"
    echo "  -> kind cluster ($CLUSTER_NAME) létrehozva."
fi

# 5. Fedél lecsukás elleni védelem engedélyezése háttérben
systemd-inhibit --what=handle-lid-switch --who="ToggleScript" --why="Laptop fedelének lecsukása melletti működés" sleep infinity &
INHIBIT_PID=$!

echo "  -> Fedél lecsukás elleni védelem aktív (PID: $INHIBIT_PID)."
echo ""
echo "=== A MÓD AKTÍV ==="
echo "Nyomj [CTRL + C]-t a kikapcsoláshoz és a visszaállításhoz."

# A script nyitva tartása a megszakításig
wait $INHIBIT_PID
