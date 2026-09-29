| model                          |       size |     params | backend    | ngl |  n_cpu_moe | type_k | type_v |  fa |         lm |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ---------: | -----: | -----: | --: | ---------: | --------------: | -------------------: |
| qwen35moe 35B.A3B IQ2_M - 2.7 bpw |  10.72 GiB |    34.66 B | CUDA       |  99 |         22 |   q8_0 |   q8_0 |   1 |       none |           pp512 |       861.76 ± 21.67 |
| qwen35moe 35B.A3B IQ2_M - 2.7 bpw |  10.72 GiB |    34.66 B | CUDA       |  99 |         22 |   q8_0 |   q8_0 |   1 |       none |          pp4096 |        824.72 ± 7.54 |
| qwen35moe 35B.A3B IQ2_M - 2.7 bpw |  10.72 GiB |    34.66 B | CUDA       |  99 |         22 |   q8_0 |   q8_0 |   1 |       none |           tg128 |         45.98 ± 0.65 |

build: 8ea290247 (10917)
