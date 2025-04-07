# Fuzzing pdfparser

## Подготовка окружения

Собираем docker образ:

```
docker build --network=host --tag=pdfparser_php_workshop_img .
```

Запускаем контейнер:

```
docker run --rm -v "$(pwd)/assets/:/root/assets" -it --network=host pdfparser_php_workshop_img /bin/bash
```

Применяем патч:

```
cd /root/pdfparser
git apply ../assets/add_fuzz.patch
```

## Подготовка корпуса

В качестве корпуса будут использоваться тестовые pdf файлы из библиотеки

## Фаззинг php кода с помощью PHP-Fuzzer

Создаем директорию для найденных падений

```
cd /root
mkdir crashes && cd crashes
```

Запускаем фаззинг PDF парсера

```
cd /root/crashes
php-fuzzer fuzz /root/pdfparser/tests/fuzz/fuzz_target.php /root/pdfparser/samples/
```

Использование словаря

```
cd /root/crashes
php-fuzzer fuzz /root/pdfparser/tests/fuzz/fuzz_target.php /root/pdfparser/samples/ --dict /root/assets/pdf.dict
```

В случае нахождения падения есть возможность минимизировать его и посмотреть на его вывод

```
cd /root/crashes
php-fuzzer minimize-crash /root/pdfparser/tests/fuzz/fuzz_target.php  /root/crashes/crash-HASH.txt
php-fuzzer run-single /root/pdfparser/tests/fuzz/fuzz_target.php minimized-HASH.txt  

Копируем результат фаззинга на хост

```
cp -r /root/crashes/root/assets
```

## Сбор покрытия

Создаем директорию для покрытия

```
cd /root
mkdir coverage
```

Генерируем html отчёт 

```
cd /root
php-fuzzer report-coverage pdfparser/tests/fuzz/fuzz_target.php pdfparser/samples/ coverage/
```
Копируем результат покрытия на хост

```
cp -r /root/coverage /root/assets
```

