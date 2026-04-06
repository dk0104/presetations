---
title: Обеспечение безопасности в Kubernetes
author: Denis Keksel
---


<!-- speaker_note: Nach den tech. gegebenheiten fragen -->


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

<!-- column_layout: [1,3,1] -->
<!--column: 1 -->
# Цель Занятия
<!--
speaker_note: |
1. Role-Based Access Control 
Mittels RBAC sollen Benutzer und Service-Accounts  
-->
- Kubernetes Security Best Practices: Top 10 Essentials  
    1. Role-Based Access Control (RBAC)
    2. Network Policies for Microservices  
    3. Secrets Management with Vault or Kubernetes Secrets  
    4. Pod Security Admission (PSA)  
    5. Regular Pod Image Scanning  
    6. Audit Logging and Monitoring
<!-- end_slide -->

<!-- column_layout: [1,3,1] -->
<!--column: 1 -->
# Маршрут вебинара
- Теория и мотивация   
- Управление доступом и настройка ролей
- Сетевые политики для микросервисов  
- Управление секретами с помощью Vault 


<!-- end_slide -->
## Знакомство с Инструментами

<!-- 
speaker_note: |
    AWK is a versatile programming language and command-line utility designed for text processing, particularly in Unix-like operating systems. Developed in 1977 by Alfred Aho, Peter Weinberger, and Brian Kernighan,

    Key Features of AWK  

    1. **Pattern-Scanning and Processing**  
       AWK processes text line by line, applying rules defined by patterns and actions. For example, the command `awk '/error/ {print $1}' error.log` searches for lines containing the word "error" and prints the first field (e.g., a timestamp or log level). This approach allows users to filter and transform data efficiently.  

    2. **Text Manipulation Capabilities**  
       AWK supports string operations, arithmetic calculations, and conditional logic. It can handle tasks like:  
       - Extracting specific fields (e.g., `print $3` to output the third column of a CSV file).  
       - Replacing text with `sub(/old/, "new")` or `gsub(/pattern/, "replacement")`.  
       - Counting occurrences of a word: `awk '{count[$0]++} END {for (i in count) print i, count[i]}' data.txt`.  

    3. **Built-in Variables and Arrays**  
       AWK provides predefined variables like `NR` (number of records processed) and `FS` (field separator). Users can also create arrays for storing and analyzing data. For instance, `arr[$1]++` counts the frequency of each unique value in the first field.  

    4. **Integration with Shell Scripts**  
       AWK is often used in shell scripts to automate repetitive tasks. Example:  

       awk -F',' '{print $1, $2}' data.csv

       This command splits a CSV file by commas and prints the first two fields, demonstrating AWK's flexibility in handling structured data.  
-->



# Basic Linux tools
<!-- column_layout: [1,2] -->
<!--column: 0 -->
- AWK
 ```bash +no_background +line_numbers
 awk -F',' '{print $1, $2}' data.csv 
 ``` 
 - SED
  ```bash +no_background +line_numbers
  sed 's/apple/orange/' input.txt 
  ``` 
 - Fzf
 ```bash +no_background +line_numbers
 k get log po test | fzf 
 ``` 

<!-- reset_layout -->
<!-- end_slide -->
# kubectl
- kubectl --help
 ```bash +exec +no_background +line_numbers
kubectl get pod --help 
 ``` 
<!-- end_slide -->
- kubectl --explain
 ```bash +exec +no_background +line_numbers
kubectl explain pod --recursive 
 ``` 
<!-- end_slide -->
- kubectl krew 
 ```bash +exec +no_background +line_numbers
 kubectl krew -h 
 ``` 
<!-- end_slide -->
# Первичный осмотр: kubectl get, top
- cluster dump
```bash  +no_background +line_numbers
kubeclt cluster-info dump
``` 
- Show events ( possible with --watch)
 ```bash +exec +no_background +line_numbers
kubeclt get events 
 ``` 
<!-- end_slide -->
# Первичный осмотр: kubectl get, top
- Get entities ( possible with --watch)
 ```bash +exec +no_background +line_numbers
 kubectl get pods -l app=frontend -n demo-app 
 ``` 
  ```bash +no_background +line_numbers
kubectl top node 
kubectl top pode --sort-by=memory
  ``` 
<!-- end_slide -->
# Диагностика: kubectl describe, logs
- Describe информации о состоянии объекта
 ```bash +exec +no_background +line_numbers
kubectl describe -n demo-app pod loadgenerator-5c7cbd94ff-lvv2r    
 ``` 

<!-- end_slide -->
# Диагностика: kubectl describe, logs
- logs основной способ анализа
 ```bash +exec +no_background +line_numbers
kubectl logs -n demo-app -l app=frontend --tail=10 
 ``` 

## Базовый цикл диагностики инцидента 
[k8s.io mini tutorial](https://kubernetes.io/docs/tasks/debug/debug-cluster/)
1. GET
> [!TIP]
> Найти нужные компоненты  
>

2. DESCRIBE
> [!TIP]
> Собрать информацию , выяснить актуальный статус.
>

3. LOG
> [!TIP]
> Выяснить причину сбоя.
>

4. WATCH
> [!TIP]
> Выяснить причину сбоя.
>

5. EXEC
> [!TIP]
> Выяснить причину сбоя.
>
<!-- end_slide -->
# How complex systems fail
[How complex Systems fail](https://how.complexsystems.fail/)

<!-- end_slide -->
# TTD TTM TTR
🧩 Пример сценария
У вас есть веб-приложение для электронной коммерции запущен в производство.
В 10:00 утра, новое развертывание микросервиса =emailservice= приводит к утечке памяти в службе оформления заказа.
## TTD
🔍 Время обнаружения (TTD)
Определение:
Время, необходимое для того, чтобы диагностические данные об инциденте дошли до групп разработки и эксплуатации.

📌 Что происходит
10:00 утра – Использование памяти начинает быстро расти Система мониторинга собирает показатели и журналы
Оповещение срабатывает, когда память пересекает порог оповещение доходит до дежурного инженера DevOps

⏱️ Измерение
Предупреждение получено по адресу 10:05 утра
<!--
speaker_note: |
    TTD Time to detect
    Более короткий TTD означает, что проблемы замечаются быстрее
    Длительный TTD часто приводит к сбоям в работе клиентов еще до того, как команды узнают о наличии проблемы
-->
## TTM
🛠️ Время смягчения (TTM)
Определение:
Время, необходимое командам для обработки данных мониторинга и снижения последствий инцидента.

📌 Что происходит
10:05 утра – Получено оповещение Инженер проверяет панели мониторинга и трассировки
Выявляет всплеск памяти службы оформления заказа Масштабирует ноды и перезапускает затронутые контейнеры для стабилизации обслуживания
⏱️ Измерение
Смягчение последствий завершено в 10:15 утра
<!--
speaker_note: |
    TTM Time to mitigate
    Смягчение последствий не устраняет основную причину
    Он восстанавливает доступность услуг и ограничивает влияние на клиентов
-->
🔧 Время на исправление (TTR)
Определение:
Время, необходимое для выявления и окончательного устранения первопричины инцидента.

📌 Что происходит
10:15 утра – Сервис стабилизирован
Инженеры анализируют журналы и следы
Основная причина определена как утечка памяти в новом коде
Код исправлен, протестирован и повторно развернут
⏱️ Измерение
TTR завершено в 12:15 
<!--
speaker_note: |
  TTR измеряет инженерную эффективность
  Длительный TTR увеличивает вероятность повторных инцидентов
-->
🏁 Ключевые выводы
- 🚨 ТТД это о видимость
- 🛠️ ТТМ это о контроль ущерба
- 🔧 ТТР это о постоянная резолюция
<!--
speaker_note: |
    Высокопроизводительные команды DevOps сосредоточены на сокращение всех трех, с особым акцентом на быстрое обнаружение и смягчение последствий для защиты клиентов и доходов.Высокопроизводительные команды DevOps сосредоточены на сокращение всех трех, с особым акцентом на быстрое обнаружение и смягчение последствий для защиты клиентов и доходов.
-->
<!-- end_slide -->
# HADI 
> [!IMPORTANT]
> Цикл HADI — это практичный способ использования данных. Аббревиатура HADI образована от основных шагов программы  
> - H-Hypothesis: Гипотезы 
> - A Actions:    Действия 
> - D Datat:      Данные 
> - I Insights:   Понимание
> 

Из чего состоит HADI?
- H — Гипотеза. Это всегда запускает цикл.
- А — Действие. Чтобы принять или отвергнуть гипотезу, нужно принять действия. Этот раздел необходим для описания действий и их последующей реализации.
- D — Данные. Тогда пришло время собрать данные. В этом разделе дано описание параметров, которые должны изменяться под влиянием действий, и способов регистрации этих изменений.
- I — Прозрения. Последняя итерация цикла — Инсайты. На основании собранных данных мы можем судить, достигли ли мы своих целей или нет. Возможно, гипотеза полезна, но нуждается в некотором улучшении. Необходимо добавить эту информацию в соответствующий раздел и попытаться повторить цикл.

<!--
speaker_note: |
- Mehrere zuecklen zullessig aber zu viele zerstoeren das resulta
- Zusehen dass die hypothesen schnell realisierbar sind
- Nich nur die realisiurung sondern auch die filter funktionene der methoden sind wichtig 
-->


<!-- reset_layout -->
<!-- end_slide -->

```d2 +render
my_table: {
  shape: sql_table
  id: int {constraint: primary_key}
  last_updated: timestamp with time zone
}
```

