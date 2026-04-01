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

- иметь представление об имеющихся модулях Terraform для создания инфраструктуры в Yandex Cloud;
- написать свой pipelines для GitLab для создания инфраструктуры.


# План Работы 
## Terraform локально
- yc cli
- yc modules
- yc managed services
- tf stages init/plan/apply/destroy

## Terraform CI/CD
- gitlab repo setup
- env vars
- ci/cd pileline

<!-- end_slide -->

# Terraform локально
## Установим yc cli
  [YC Dokumentation](https://yandex.cloud/en/docs/cli/quickstart)
```shell
yc intit
yc config list 
yc vpc network --help
yc compute image list --folder-id standard-images
```
- Прмеры использования

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

## Environment Setup
- Direnv 
[Direnv](https://direnv.net/)

```shell

export YC_SERVICE_ACCCOUNT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxx
export YC_TOKEN=$(yc iam create-token --impersonate-service-account-id ajeu88p4fr44t5lo1v0n)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_COMPUTE_ZONE=$(yc config get compute-default-zone)

export TF_VAR_yc_token=$YC_TOKEN
export TF_VAR_yc_cloud_id=$YC_CLOUD_ID
export TF_VAR_yc_folder_id=$YC_FOLDER_ID
export TF_VAR_yc_compute_zone=$YC_COMPUTE_ZONE

export TF_VAR_ssh_public_key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzKo0ViSsU2NgnrxqYKhAeyIG0No1dsda+hKffh3YtB dk@mars"

```

<!-- end_slide -->

## Создадим проект в гитлаб

1. Coздадим локальной репозитрий для хранения терафом кода

- Otus gitlab.

2. Настооим ingore files. 

> [!CAUTION]
> Terraform state 
> Environment vars
> Tokens and Keys
> .

<!-- end_slide -->

## Усановим что нибудь локально
[yandex cloud  quickstart ](https://yandex.cloud/en/docs/cli/quickstart)
- simple instance

- Managed services 
[Yandex_gitlab_instance](https://yandex.cloud/ru/docs/terraform/resources/gitlab_instance)
```tf
resource "yandex_gitlab_instance" "otus_demo_gitlab_instance" {
  name                      = "otus-demo-gitlab"
  resource_preset_id        = "s2.micro"
  disk_size                 = 30
  admin_login               = "otusGitlabAdmin"
  admin_email               = "denis.keksel@keksel.pro"
  domain                    = "otus-demo-gitlab.gitlab.yandexcloud.net"
  subnet_id                 = yandex_vpc_subnet.otus-demo-subnet-1.id
  approval_rules_id         = "BASIC"
  backup_retain_period_days = 30
  deletion_protection       = false
}
```
<!-- end_slide -->

- [Yandex container optimized] (https://yandex.cloud/ru/docs/compute/tutorials/coi-with-terraform)

```tf
resource "yandex_compute_instance" "instance-based-on-coi" {
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }
  network_interface {
    subnet_id = "<идентификатор_подсети>"
    nat = true
  }
  resources {
    cores = 2
memory = 2
  }
  metadata = {
    docker-container-declaration = file("${path.module}/declaration.yaml")
    user-data = file("${path.module}/cloud_config.yaml")
  }
}
```
<!-- end_slide -->

# Terraform CI/CD
## Project Structure

### Добавим файл .terraformrc для настройки провайдера внутри Gitlab Runner

### Создадим .gitlab-ci.yml для настройки CI/CD со стадиями

- Standard steps 
* validate
* plan
* apply
* destroy (Manual)


### Добавим переменные окружения в пайплайн для хранения terraform-state файла в Gitlab
### Добавим переменные окружения от облака Yandex Cloud в Gitlab на уровне проекта:

* TF_VAR_yc_token
* TF_VAR_yc_cloud_id
* TF_VAR_yc_folder_id
* TF_VAR_ssh_public_key


### Запушим репозиторий в Gitlab
- [glab](https://docs.gitlab.com/cli/) cli gitlab tol

### Проверим работу CI/CD пайплайна



