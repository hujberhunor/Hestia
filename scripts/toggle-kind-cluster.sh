#!/usr/bin/env bash

# Kilépéskor automatikusan lefutó helyreállító függvény (SIGINT, SIGTERM vagy normál exit esetén)
cleanup() {
    echo -e "\n[+] Leállítás: Visszaállítás az eredeti állapotra..."

    # 1. kind cluster törlése
    kind delete cluster --name hestia-local 2>/dev/null
    echo "  -> kind cluster törölve."

    # 2. Docker daemon leállítása
    sudo systemctl stop docker.service docker.socket
    echo "  -> Docker daemon leállítva."

    # 3. Tűzfal szabály törlése és SSH leállítása
    sudo iptables -D INPUT -p tcp --dport 22 -s 192.168.111.0/24 -j ACCEPT 2>/dev/null
    sudo systemctl stop sshd.service
    echo "  -> SSH szerver leállítva, tűzfalszabály törölve."

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
# Először töröljük a biztonság kedvéért, ha korábbról bent maradt volna, majd hozzáadjuk
sudo iptables -D INPUT -p tcp --dport 22 -s 192.168.111.0/24 -j ACCEPT 2>/dev/null
sudo iptables -A INPUT -p tcp --dport 22 -s 192.168.111.0/24 -j ACCEPT

echo "  -> SSH fut és elérhető a 192.168.111.0/24 subnetből."

# 2. Docker daemon elindítása
sudo systemctl start docker.service
echo "  -> Docker daemon elindítva."

# 3. kind cluster létrehozása (vagy újrahasznosítása, ha már létezik)
if kind get clusters 2>/dev/null | grep -qx "hestia-local"; then
    echo "  -> kind cluster (flux-test) már létezik, újrahasználva."
else
    kind create cluster --name hesita-local
    echo "  -> kind cluster (flux-test) létrehozva."
fi

# 4. Fedél lecsukás elleni védelem engedélyezése háttérben
systemd-inhibit --what=handle-lid-switch --who="ToggleScript" --why="Laptop fedelének lecsukása melletti működés" sleep infinity &
INHIBIT_PID=$!

echo "  -> Fedél lecsukás elleni védelem aktív (PID: $INHIBIT_PID)."
echo ""
echo "=== A MÓD AKTÍV ==="
echo "Nyomj [CTRL + C]-t a kikapcsoláshoz és a visszaállításhoz."

# A script nyitva tartása a megszakításig
wait $INHIBIT_PID
