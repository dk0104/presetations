---
title: Gitlab  Terraform K8S 
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

# План Работы 
1. Создадим проект в гитлаб
2. Coздадим локальной репозитрий для хранения терафом кода
3. Runner Installieren

# Terraform setup 
- yc installieren (yc installiren)

# Terraformm umgebung erstellen
- yandex_commspute_instance erstellen
- yndex_compute_disk 
- image id finden (yc compute image list)
- allow stopping for update nicht vergessen

> [!CAUTION]
> Terraform stage umbedingt zu ignore hinzyfuegen
> .

- terraform backend erzeugen
- terraform states speichern - wie
- yc iam create token ??? 
- TF_VAR_ erklaeren

**text** 


links:
[yandex cloud  quickstart ](https://yandex.cloud/en/docs/cli/quickstart)

```shell
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
yc init

```

```.direnv

export YC_TOKEN=$(yc iam create-token --impersonate-service-account-id ajej1la649a5s17pafi7)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_COMPUTE_ZONE=$(yc config get compute-default-zone)

export TF_VAR_yc_token=$YC_TOKEN
export TF_VAR_yc_cloud_id=$YC_CLOUD_ID
export TF_VAR_yc_folder_id=$YC_FOLDER_ID
export TF_VAR_yc_compute_zone=$YC_COMPUTE_ZONE

```

```shell
yc iam service-account create --name < Service Account Name > \
  --description "Service account description"
```
[assign-role-for-sa](https://yandex.cloud/en/docs/iam/operations/sa/assign-role-for-sa#cli_1)

```shell
yc resource-manager <resource_category> add-access-binding <resource_name_or_ID> \
  --role <role_ID> \
  --subject serviceAccount:<service_account_ID>

```
Где:
- <категория_ресурса> — cloud, чтобы назначить роль на облако, или folder, чтобы назначить роль на каталог.
- <имя_или_идентификатор_ресурса> — имя или идентификатор ресурса, на который назначается роль.
- --role — идентификатор роли, например viewer.
- --subject serviceAccount — идентификатор сервисного аккаунта, которому назначается роль.

```shell
yc resource-manager cloud add-access-binding $YC_CLOUD_ID --role admin --subject serviceAccount:$YC_SERVICE_ACCCOUNT_ID
```
