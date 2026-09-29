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

| Rol | Model | Dosya | Bağlam | Port | Not |
|---|---|---|---|---|---|
| Kodlama | Qwen3.6-35B-A3B-UD-**IQ2_M** | 10.73 GB | 65536 | 8080 | `--reasoning off`, MoE katmanlarının bir kısmı CPU'da |
| Planlama | Qwen3.5-9B-UD-**Q4_K_XL** | 5.56 GB | 32768 | 8081 | `--reasoning on`, tamamen VRAM'de |

Her ikisi de `--parallel 1` ile, tek istemci için, yalnız `127.0.0.1`'de dinliyor.

### Modeller nereden

İkisi de [Unsloth](https://huggingface.co/unsloth)'un GGUF kuantizasyonları (dosya
başlığındaki `general.quantized_by` alanı: Unsloth). Orijinal modeller:
[Qwen/Qwen3.6-35B-A3B](https://huggingface.co/Qwen/Qwen3.6-35B-A3B) ve
[Qwen/Qwen3.5-9B](https://huggingface.co/Qwen/Qwen3.5-9B). Dosya adları yukarıdaki
tablodakiyle birebir aynı; lisans için orijinal model sayfasına bak.

## Script'ler

[`scripts/`](scripts/) klasöründe, Windows `cmd` için:

| Script | Ne yapar |
|---|---|
| `durum.cmd` | Hangi model açık, ne kadar RAM/VRAM kullanıyor |
| `start-qwen.cmd` | Kodlama modelini başlatır (64K bağlam) |
| `start-qwen-lean.cmd` | Kodlama modeli, hafif: 32K bağlam, `NCMOE=20`. Boş RAM 1.5 GB altına düştüğünde |
| `start-plan.cmd` | Planlama modelini başlatır |
| `stop-qwen.cmd` | Çalışan **tüm** `llama-server.exe` süreçlerini kapatır |

Akış her zaman aynı: **durum → (açıksa) durdur → başlat.** Başlatma script'leri başka bir
model açıksa başlamayı reddediyor.

Varsayılan yollar `C:\llama.cpp\llama-server.exe` ve `C:\llama.cpp\models\`. Farklıysa
çağırmadan önce ez:

```cmd
set "LLAMA_DIR=D:\araclar\llama.cpp"
set "MODEL=D:\modeller\Qwen3.6-35B-A3B-UD-IQ2_M.gguf"
start-qwen.cmd
```

`CTX`, `NCMOE` ve `PORT` da aynı şekilde ezilebilir. Tam bayrak listesi script'lerin içinde.

## Ölçülmüş bayraklar

Varsayılan ayarlarla başlayıp tek tek ölçerek düşürdüğüm tepe bellek kullanımı
(kodlama modeli):

| Bayrak | Ne yapıyor | Önce | Sonra |
|---|---|---|---|
| `--cache-ram 1024` | Sunucunun RAM'deki prompt önbelleğini sınırlar; varsayılan 8192 MiB sistemi sayfalama dosyasına itiyordu | 8.20 GB RAM | 7.05 GB RAM, hız kaybı yok |
| `--load-mode none` | `--n-cpu-moe` ile birlikte mmap'in çift tamponlamasını (page cache + CPU tensör kopyası) kapatır | 8.75 GB RAM | 5.34 GB RAM |
| `--cache-type-k/v q8_0` | KV önbelleğini yarıya indirir | 32K bağlam, f16 KV | 64K bağlam, q8_0 KV — yine daha az VRAM |

`--n-cpu-moe 22` 64K bağlamla eşleşiyor. `q8_0` KV'de 32K bağlamda 3 iğneli geri
getirim testi 3/3 isabet — kalite kaybı gözlemedim.

Qwen3.6-35B-A3B hibrit dikkatli bir MoE: 40 katmanın yalnız 10'u tam dikkat, kalanı
doğrusal (GatedDeltaNet). KV önbelleği bu yüzden küçük ve 35B'lik bir model 8 GB'lık
karta bu sayede sığıyor.

## Planlama modeliyle çalışırken

- Sunucu düşünme açık başlıyor. Kısa, yapılandırılmış işlerde (özetleme, sınıflandırma)
  istekte `enable_thinking: false` gönder — yoksa token bütçesi düşünmeye gidiyor ve
  `content` boş dönebiliyor.
- `frequency_penalty` vermeyince tekrar döngüsüne düştüğünü gördüm.
- Prompt'a konan somut few-shot örneklerini cevap diye geri yazabiliyor.
- `--reasoning off/on`, bu build'de kaldırılan
  `--chat-template-kwargs '{"enable_thinking":false}'` kullanımının yerini alıyor.

## Neden iki farklı model

35B@IQ2_M ile yaptığım bir sohbette olgusal bir uydurma yakaladım; kod işinde benzer bir
bozulma görmedim. Bu yüzden olgu/muhakeme gerektiren işi 9B@Q4_K_XL'e, kodu 35B@IQ2'ye
ayırdım. Nedenin kuantizasyon mu model mi olduğu ayrılamıyor — ayrıntı:
[bulgu-iq2-halusinasyon.md](bulgu-iq2-halusinasyon.md).

## Sınırlar

- **Araştırma bir model sorunu değil.** Hiçbir yerel model araştırma yapamaz — geri
  getirime (retrieval) ihtiyacı var, hafızaya değil. Belge vermeden ya da web aramasına
  bağlamadan olgu/tarih/isim sorma.
- **Arka planda kalan sunucu:** llama-server penceresiz başlatılırsa sessizce ~7 GB RAM ve
  VRAM tutmaya devam ediyor. Emin değilsen `durum.cmd`, kapatmak için `stop-qwen.cmd`.
- Bu ölçümler **tek makinede, tek kullanım deseninde** alındı; farklı donanımda ya da
  bağlam uzunluğunda sayılar değişir. Genel bir kıyaslama değil, benim ölçtüğüm sayılar.
  Kendi makinende denediysen [sayılarını paylaş](https://github.com/tungarix/yerel-llm-8gb/issues/new?template=olcum.md).
