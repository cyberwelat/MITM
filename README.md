====================================================
       Bettercap MITM Otomasyon Scripti - README
====================================================

Bu script, yerel ağda Bettercap aracı ile otomatik MITM (Man-in-the-Middle) saldırısı gerçekleştirmek amacıyla yazılmıştır. Kullanıcı dostu yapısı sayesinde hedef belirlemek, DNS spoofing ve trafik takibi işlemleri kolayca yapılabilir.

----------------------------------------
🔧 Özellikler:
----------------------------------------

- Otomatik ağ arayüzü tespiti
- Bettercap yüklü değilse otomatik kurulum
- Ağdaki cihazları tespit etmek için tarama yapar
- Liste üzerinden hedef IP seçimi
- Belirli alan adları için DNS spoofing işlemi
- ARP spoofing aktif edilir
- Tüm trafik `mitm.pcap` dosyasına kaydedilir
- Renkli terminal çıktıları ile anlaşılır uyarılar sağlar

----------------------------------------
📦 Gereksinimler:
----------------------------------------

- Linux sistem (Parrot, Kali, Ubuntu vb.)
- Bettercap (script otomatik kurar)
- sudo yetkisi
- Bash terminal

----------------------------------------
🚀 Kullanım:
----------------------------------------

1. Script’e çalıştırma izni ver:
   chmod +x mitm.sh

2. Script’i başlat:
   ./mitm.sh

3. Script çalıştığında:
   - Ağ arayüzünüz otomatik algılanır.
   - Bettercap yüklü değilse yüklenir.
   - Ağ taraması yapılır.
   - Listelenen cihazlardan hedef IP seçersiniz.
   - Yönlendirmek istediğiniz alan adını girersiniz (örn: facebook.com).
   - MITM saldırısı başlar ve trafik kaydedilir.

----------------------------------------
📁 Çıktılar:
----------------------------------------

- bettercap_output.txt → Ağ tarama sonuçları
- mitm.pcap            → Yakalanan trafik verisi

----------------------------------------
⚠️ Uyarı:
----------------------------------------

Bu araç yalnızca eğitim ve yetkili ağlarda güvenlik testleri amacıyla kullanılmalıdır. İzinsiz kullanımı **yasalara aykırıdır** ve cezai sorumluluk doğurabilir.

----------------------------------------

Geliştirici: cyberwelat  
Dağıtım: Parrot OS - Ethical Hacking Toolkit
