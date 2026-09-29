# Kurulum: 8 GB VRAM'de iki büyük model

Agentic kodlamayı tamamen yerelde çalıştırıyorum — ücretli API yok. llama.cpp üzerinde
iki Qwen modeli, **asla aynı anda değil**, tek 8 GB'lık karta göre ayarlanmış bayraklarla.

## Donanım tavanı

| | |
|---|---|
| GPU | RTX 5050 Laptop — 8 GB VRAM (~7.0 GB kullanılabilir) |
| CPU | Ryzen 7 250, 8 çekirdek/16 thread (Zen4 → AVX-512 CPU backend) |
| RAM | 16 GB DDR5-5600, tek kanal |

Bağlayıcı kısıt **VRAM değil RAM** çıktı — bayrakların çoğu bunun için var.

## İki model, iki rol

8 GB VRAM'e ikisi birden sığmıyor, o yüzden hiçbir zaman ikisi aynı anda açık değil:

| Rol | Model | Boyut | Bağlam | Not |
|---|---|---|---|---|
| Kodlama | Qwen3.6-35B-A3B-UD-**IQ2_M** | 10.73 GB | 65536 | `--reasoning off`, thinking kapalı |
| Planlama | Qwen3.5-9B-UD-**Q4_K_XL** | 5.56 GB | 32768 | `--reasoning on`, tamamen VRAM'de |

Her ikisi de `--parallel 1` ile, tek istemci için. Başlatma/durdurma script'leri diğer
model açıksa başlatmayı reddediyor — kazara ikisini birden açmamak için.

## Ölçülmüş bayraklar

Varsayılan ayarlarla başlayıp tek tek ölçerek düşürdüğüm tepe bellek kullanımı:

| Bayrak | Ne yapıyor | Önce | Sonra |
|---|---|---|---|
| `--cache-ram 1024` | Varsayılan 8192 MiB'lık disk önbelleğini sınırlar (sayfalama dosyasına düşmeyi engeller) | 8.20 GB RAM | 7.05 GB RAM |
| `--load-mode none` | `--n-cpu-moe` ile mmap'in çift tamponlanmasını (page cache + CPU tensor kopyası) engeller | 8.75 GB RAM | 5.34 GB RAM |
| `--cache-type-k/v q8_0` | KV önbelleğini yarıya indirir | 32K bağlam f16'dan daha az VRAM | ölçülebilir kalite kaybı yok |

`--n-cpu-moe 22` 64K bağlamla eşleşiyor. `q8_0` KV kuantizasyonunda 32K bağlamda 3 iğneli
geri getirim testi hâlâ 3/3 isabet — kalite kaybı gözlenmedi.

`--reasoning off` bu build'de kullanımdan kalkmış bir eski bayrağın (`--chat-template-kwargs
'{"enable_thinking":false}'`) yerini alıyor. Planlama modelinde `enable_thinking: false`
verilmezse thinking token bütçesi tükeniyor ve `content` boş dönüyor.

## Neden iki farklı model

IQ2_M (2.7 bit/ağırlık) kod yeteneğinden çok **olgusal hatırlamayı** eziyor — ayrıntı ve
somut örnek: [bulgu-iq2-halusinasyon.md](bulgu-iq2-halusinasyon.md). Bu yüzden olgu/muhakeme
önemli olan planlama işini 9B@Q4_K_XL'e (~4.8 bit/ağırlık), kod işini 35B@IQ2'ye ayırdım.

## Sınırlar

- **Araştırma bir model sorunu değil.** Hiçbir yerel model gerçek zamanlı araştırma
  yapamaz — geri getirime (retrieval) ihtiyacı var, hafızaya değil. Belge verilmeden ya
  da web aramasına bağlanmadan olgu/tarih/isim sorma.
- Bu ölçümler **tek makinede, tek kullanım deseninde** alındı — farklı donanımda veya
  farklı bağlam uzunluğunda sayılar değişir. İddia genel bir kıyaslama değil, benim
  ölçtüğüm sayılar.

## Lisans

MIT.
