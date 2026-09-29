| model                          |       size |     params | backend    | ngl | type_k | type_v |  fa |         lm |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | -----: | -----: | --: | ---------: | --------------: | -------------------: |
| qwen35 9B Q4_K - Medium        |   5.55 GiB |     8.95 B | CUDA       |  99 |   q8_0 |   q8_0 |   1 |       none |           pp512 |      1741.65 ± 30.03 |
| qwen35 9B Q4_K - Medium        |   5.55 GiB |     8.95 B | CUDA       |  99 |   q8_0 |   q8_0 |   1 |       none |          pp4096 |       1710.32 ± 3.70 |
| qwen35 9B Q4_K - Medium        |   5.55 GiB |     8.95 B | CUDA       |  99 |   q8_0 |   q8_0 |   1 |       none |           tg128 |         54.19 ± 0.55 |

build: 8ea290247 (10917)
