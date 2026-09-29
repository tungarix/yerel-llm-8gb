# Ham örnek yanıt — 35B (start-qwen.cmd, port 8080)

Elle dokunulmadı. Tek istek, tek örnek.

**İstek:** `Python'da bir metindeki en sık geçen 5 kelimeyi bulan bir fonksiyon yaz. collections.Counter kullan, kısa docstring ekle.`
`temperature=0.7`, `max_tokens=400`. Sunucu zamanlaması: 44 prompt token, 185 üretilen token, 71.9 tok/s (prompt), 43.9 tok/s (üretim). `finish_reason: stop`.

**Yanıt:**

```python
from collections import Counter


def top_5_words(text: str) -> list[str]:
    """Metindeki en sık geçen 5 kelimeyi döndürür.

    Kelimeler büyük/küçük harke duyarlı olmadan, sadece alfabetik karakterler
    dikkate alınarak sayılır.

    Args:
        text: Kelimeleri sayılacak metin.

    Returns:
        En sık geçen 5 kelime ve sayıları içeren (kelime, sayı) tuple'larından oluşan liste.
    """
    # Metni küçük harfe çevir ve sadece harf/rakam içeren kelimeleri ayır
    words = [word.lower() for word in text.split() if word.isalnum()]
    counts = Counter(words)
    return counts.most_common(5)
```
