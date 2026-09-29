# Bulgu: IQ2 kuantizasyonunda olgusal halüsinasyon

**Tek gözlem, tek makine — sıkı bir kıyaslama değil.** Ama somut, tekrarlanabilir ve
kararımı değiştirdi, o yüzden yazıyorum.

## Ne oldu

Kodlama modelim olan Qwen3.6-35B-A3B'yi (IQ2_M kuantizasyon, 2.7 bit/ağırlık) bir futbol
konusunda sohbette test ederken, model **gerçekte var olmayan bir futbolcu ismi** uydurdu:
"Sergen Yılmaz" — iki gerçek Türk futbolcusunun (Sergen Yalçın, Arda Turan'ın kuşağından
başka bir isim) ismini birbirine karıştırarak üretilmiş, hiç var olmamış bir isim.

Asıl ilginç kısım itiraz edildiğinde oldu: modele bu ismin uydurma olduğunu söyleyince,
model **ısrar etti** — geri adım atmadı, özür dilemedi, "haklısınız" demedi. Kendi
uydurduğu ismi savundu.

## Neden önemli

İsim karıştırma (gerçek parçalardan sahte bir bütün üretmek) + hataya itiraz edilince
ısrar etmek (sahte özgüven) birlikte, çok düşük bit kuantizasyonunun tipik imzası.
Modelin dil/kod yeteneği IQ2_M'de gözle görülür bozulmuyor — ama olgusal hafıza ve
"bilmiyorum" diyebilme yeteneği bozuluyor.

## Sonuç: iki modele ayırdım

| İş türü | Model | Neden |
|---|---|---|
| Kod yazma | 35B @ IQ2_M | Kod yeteneği bu kuantizasyonda hâlâ iyi |
| Olgu/muhakeme gerektiren planlama | 9B @ Q4_K_XL (~4.8 bit/ağırlık) | Daha yüksek bit, daha az halüsinasyon |

Pratik kural: **olgu, tarih, isim gerektiren hiçbir şeyi düşük-bit kuantize bir modele
sorma** — ya belge ver (bağlam-içi okuma bu modellerde iyi çalışıyor) ya da web
aramasına bağla. Kuantize model hafızasından değil, önüne konan metinden doğru cevap
üretir.

## Metodoloji notu

Bu tek bir oturumda yakalanan tek bir örnek — sistematik bir kuantizasyon-halüsinasyon
kıyaslaması yapmadım (henüz). Genellenebilirliği test etmek istersem sıradaki adım aynı
soruyu farklı kuantizasyon seviyelerinde (Q4, Q5, Q8) tekrarlayıp halüsinasyon oranını
saymak olurdu. Şu an için bu, "IQ2_M'i olgu gerektiren işte kullanma" kararımın kaynağı —
kanıtın kendisi, iddia değil.
