# Fuzzing php workshop

## PHP-Fuzzer

### Подготовка окружения

Собираем docker образ:

```sh
docker build --network=host --tag=pdfparser_php_workshop_img .
```

Запускаем контейнер:

```sh
docker run --rm -v "$(pwd)/assets/:/root/assets" -it --network=host pdfparser_php_workshop_img /bin/bash
```

Применяем патч:

```sh
cd /root/pdfparser
git apply ../assets/add_fuzz.patch
```

### Подготовка корпуса

В качестве корпуса будут использоваться тестовые pdf файлы из библиотеки

### Фаззинг php кода с помощью PHP-Fuzzer

Создаем директорию для найденных падений

```sh
cd /root
mkdir crashes && cd crashes
```

Запускаем фаззинг PDF парсера

```sh
cd /root/crashes
php-fuzzer fuzz /root/pdfparser/tests/fuzz/fuzz_target.php /root/pdfparser/samples/
```

Использование словаря

```sh
cd /root/crashes
php-fuzzer fuzz /root/pdfparser/tests/fuzz/fuzz_target.php /root/pdfparser/samples/ --dict /root/assets/pdf.dict
```

В случае нахождения падения есть возможность минимизировать его и посмотреть на его вывод

```sh
cd /root/crashes
php-fuzzer minimize-crash /root/pdfparser/tests/fuzz/fuzz_target.php  /root/crashes/crash-HASH.txt
php-fuzzer run-single /root/pdfparser/tests/fuzz/fuzz_target.php minimized-HASH.txt  
```

Копируем результат фаззинга на хост

```sh
cp -r /root/crashes/root/assets
```

### Сбор покрытия

Создаем директорию для покрытия

```sh
cd /root
mkdir coverage
```

Генерируем html отчёт 

```sh
cd /root
php-fuzzer report-coverage pdfparser/tests/fuzz/fuzz_target.php pdfparser/samples/ coverage/
```

Копируем результат покрытия на хост

```sh
cp -r /root/coverage /root/assets
```
## PHUZZ

### Установка и запуск окружения

```sh
git clone https://github.com/gehaxelt/phuzz.git
cd phuzz/code/

docker compose up -d db --build --force-recreate
docker compose up -d web --build --force-recreate
```

```sh
docker compose up db --force-recreate
docker compose up web --build --force-recreate
```
После этого приложение должно быть доступно между контейнерами по порту 80 (http://web/), а также извне контейнеров по адресу http://localhost:8080, который сопоставлен с портом 80 веб-контейнера.

### Запуск фаззера 
```sh
docker compose up fuzzer-dvwa-sqli-low-1 --build --force-recreate
```
Результат будет выведен на экран и в `/fuzzer/output/`
