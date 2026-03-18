---
title: Gitlab CI/CD K8S 
author: Denis Keksel
---

<!-- column_layout: [1,3,1] -->
<!--column: 1 -->
---

* **Keksel Denis**
* 19 Jahre IT
* 5 DevOps
* Telegram: [](@dkeksel)
* Mail: [](denis.keksel@keksel.pro)
---
<!-- reset_layout -->

<!-- end_slide -->

# Практическое занятие: Настройка CI/CD в GitLab

## Цель занятия

- Научиться настраивать CI/CD в GitLab с развертыванием в Kubernetes через GitLab Kubernetes Agent

## Цели обучения
- К концу занятия вы сможете:
    - Автоматизировать сборку, тестирование и деплой приложения.
    - Создавать Helm Charts для доставки приложений в k8s
    - Настроить безопасное подключение к Kubernetes через GitLab Agent.

## План занятия
- Создать окружение ( GitLab k8s docker)
- Создание Justfile для локальной автоматизации
- Создание Helm Charta
- Создание конвейера 
- Регистрация GitLab Agent
- Deployment and Test 


## Требуемые компоненты

- GitLab аккаунт.
- Kubernetes-кластер (Minikube, k3s, GKE и т.д.).
- Установленные:
    - git, kubectl, docker, podman, helm
    - just (установка: cargo install just или через пакетный менеджер)
    - Простое приложение (Node.js, Python и т.п.).

<!-- end_slide -->

# Шаги исполнения

## Подготовка репозитория и приложения

## Создание локальной автоматизации

## Подготовка приложения с Helm

## Доставка приложения в кластер

<!-- end_slide -->
