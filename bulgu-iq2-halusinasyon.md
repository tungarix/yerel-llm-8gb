# Bulgu: IQ2 kuantizasyonunda olgusal halüsinasyon

**Tek gözlem, tek makine — kıyaslama değil.** Tekrar denenmedi. Yine de kurulumdaki
iş bölümünü değiştirdi, o yüzden yazıyorum.

## Ne oldu

Kodlama modelim Qwen3.6-35B-A3B'ye (IQ2_M kuantizasyon, ~2.7 bit/ağırlık) futbolla
ilgili bir soru sordum. Model **gerçekte var olmayan bir futbolcu ismi** verdi:
"Sergen Yılmaz". İsim, iki gerçek ismin karışımı gibi duruyor.

İsmin uydurma olduğunu söyleyince model geri adım atmadı, **ısrar etti**.

## Nasıl yorumladım

İki şey birlikte göründü:

- **İsim karıştırma:** gerçek parçalardan, gerçekte olmayan bir bütün üretmek.
- **Sahte özgüven:** itiraz edilince düzeltmek yerine savunmak.

Aynı modelde kod işinde belirgin bir bozulma görmedim. Bunu çok düşük bit
kuantizasyonunun olgusal hafızayı koddan daha çok bozmasına bağladım — ama aşağıdaki
karışık değişken yüzünden bu bir **yorum**, kanıtlanmış bir neden değil.

## Karışık değişken

Karşılaştırdığım iki kurulum iki şeyde birden farklı:

| | Kodlama | Planlama |
|---|---|---|
| Model | Qwen3.6-35B-A3B (MoE) | Qwen3.5-9B |
| Kuantizasyon | IQ2_M (~2.7 bit) | Q4_K_XL (~4.8 bit) |

Yani planlama modelinin olgu işinde daha güvenilir görünmesinin nedeni kuantizasyon da
olabilir, modelin kendisi de. Bu gözlem ikisini ayıramaz.

Ayırmanın yolu: **aynı modeli iki kuantizasyonda** (ör. 9B'yi IQ2_M ve Q4_K_XL) aynı
olgu sorularıyla denemek ve "doğru / uydurma / bilmiyorum" oranlarını saymak. Henüz
yapmadım.

## Pratik sonuç

| İş türü | Model | Neden |
|---|---|---|
| Kod yazma | 35B @ IQ2_M | Kod işinde sorun görmedim, 64K bağlam sığıyor |
| Olgu/muhakeme gerektiren planlama | 9B @ Q4_K_XL | Olgu işinde daha güvenilir göründü (bkz. karışık değişken) |

**2026-09-30 notu (tek örnek):** Kod işinde sorun görmediğim gözlemim eskiydi. Bugün 35B'ye
tek bir küçük fonksiyon yazdırdım ([ham yanıt](olcum/ham/2026-09-30-sunucu-ornek-yanit-35b.md)):
kod çalışıyor ama dönüş tipi `list[str]` diye yazılmış, oysa `Counter.most_common` demet
listesi döndürüyor; `isalnum()` süzgeci "merhaba," gibi noktalama yapışık kelimeleri
sayımdan düşürüyor; Türkçe docstring'de "harke" yazım hatası var. Tek örnek, sonuç
çıkarmak için yetersiz — ama "kodda sorun yok" demek için de.

Kuantizasyon bu bulgunun nedeni olsa da olmasa da şu kural geçerli: **olgu, tarih, isim
için yerel modelin hafızasına güvenme.** Belgeyi ver (bağlam içi okuma bu modellerde
iyi: 32K bağlamda 3 iğneli geri getirim testi 3/3) ya da web aramasına bağla.
