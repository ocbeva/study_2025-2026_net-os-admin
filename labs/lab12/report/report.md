---
## Front matter
title: "Отчёт о лабораторной работе"
subtitle: "Лабораторная работа 12"
author: "Мантуров Татархан Бесланович"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: true # List of figures
lot: true # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian4
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: IBM Plex Serif
romanfont: IBM Plex Serif
sansfont: IBM Plex Sans
monofont: IBM Plex Mono
mathfont: STIX Two Math
mainfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
romanfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
sansfontoptions: Ligatures=Common,Ligatures=TeX,Scale=MatchLowercase,Scale=0.94
monofontoptions: Scale=MatchLowercase,Scale=0.94,FakeStretch=0.9
mathfontoptions:
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Получение навыков по управлению системным временем и настройке синхронизации времени

# Выполнение лабораторной работы

На сервере посмотрим текущие параметры настройки даты и времени с помощью утилиты timedatectl. Было определено, что сервер находится во временной зоне UTC, системные часы синхронизированы, а служба NTP активна (рис. [-@fig:001]).

![Вывод команды timedatectl на сервере](image/1.png){#fig:001}

Аналогичную проверку параметров времени выполним на клиентской машине. Клиент также находится в зоне UTC, и сетевая синхронизация времени активна (рис. [-@fig:003]).

![Вывод команды timedatectl на клиенте](image/3.png){#fig:003}	

Аналогичным образом аппаратное время проверим на клиентской машине (рис. [-@fig:007]).

![Просмотр аппаратного времени на клиенте](image/7.png){#fig:007}

Проверили установлено ли на сервере необходимое программное обеспечение: ```dnf -y install chrony``` ([рис. @fig-008])

![Установка chrony на сервере](image/8.png){#fig-010 width=70%}

Проверим источники точного времени на клиентской машине. На данном этапе клиент также использует внешние пулы для синхронизации (рис. [-@fig:009]).

![Просмотр источников времени на клиенте](image/9.png){#fig:009}

Отредактируем конфигурационный файл /etc/chrony.conf на сервере. Добавим директиву allow 192.168.0.0/16, разрешающую клиентам из локальной сети запрашивать точное время (рис. [-@fig:010]).

![Настройка доступа к NTP-серверу для локальной сети](image/10.png){#fig:010}

Перезапустим службу синхронизации времени chronyd для применения изменений конфигурации, а также добавим службу ntp в исключения фаервола на сервере для входящих подключений (рис. [-@fig:011]).

![Перезапуск службы и настройка Firewall на сервере](image/11.png){#fig:011}

Отредактируем конфигурационный файл /etc/chrony.conf на клиенте. Укажем локальный сервер server.nsandryushin.net в качестве источника времени с параметром iburst для ускоренной начальной синхронизации (рис. [-@fig:012]).

![Настройка клиента на использование локального NTP-сервера](image/12.png){#fig:012}

Перезапустим службу chronyd на клиентской машине для вступления настроек в силу (рис. [-@fig:013]).

![Перезапуск службы chronyd на клиенте](image/13.png){#fig:013}

Вновь проверим источники синхронизации на сервере. Вывод подтверждает наличие активных соединений с внешними эталонными серверами (рис. [-@fig:014]).

![Проверка источников времени на сервере](image/14.png){#fig:014}

Внесём изменения в вагрант и создадим скрипт ntp.sh (рис. [-@fig:017]).

![Vagrant](image/17.png){#fig:017}

Добавим следующие изменения в файл ntp.sh (рис. [-@fig:018]).

![Содержимое скрипта настройки ntp.sh для сервера](image/18.png){#fig:018}

Аналогичные действия по подготовке окружения выполним на виртуальной машине client. Создадим исполняемый файл ntp.sh (рис. [-@fig:019]).

![Vagrant](image/19.png){#fig:019}

Добавим следующие изменения в файл ntp.sh (рис. [-@fig:020]).

![Содержимое скрипта настройки ntp.sh для клиента](image/20.png){#fig:020}

Внесём изменения в vagrantfile (рис. [-@fig:021]).

![Vagrantfile](image/21.png){#fig:021}

# Выводы

В результате выполнения лабораторной работы были получены навыки настройки системного времени и ntp синхронизации
