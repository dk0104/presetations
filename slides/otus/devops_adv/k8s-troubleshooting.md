---
title: Gitlab  Terraform CI/CD
author: Denis Keksel
---

<!-- column_layout: [1,3,1] -->
<!--column: 1 -->
---
![](./files/personal_rr.jpg)
* **Keksel Denis**
* 20 Years IT
* 5 DevOps
* Telegram: [](@dkeksel)
* Mail: [](denis.keksel@keksel.pro)
---
<!-- reset_layout -->

<!-- end_slide -->

# Цель Занятия

- Анализировать логи и метрики подов (kubectl logs, describe)
- Использовать инструменты отладки (k9s, Lens, kubectl debug)
- Диагностировать сетевые проблемы (Calico, Istio)
- Восстанавливать работоспособность кластера


# План Работы 
## Знакомство с Инструментами
### Анализ логов и метрик
### Базовый цикл диагностики инцидента 
### Инструменты отладки

<!-- end_slide -->
### Анализ логов и метрик

- kubectl Главный инструмент

 ```bash +exec +no_background +line_numbers
kubectl --help 
 ``` 

<!-- end_slide -->
```bash +exec +no_background +line_numbers
kubectl get po -n demo-app
```


