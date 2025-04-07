FROM registry.altlinux.org/alt/alt:p10

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    wget git unzip vim-console bash-completion \ 
    php8.0 php8.0-mbstring php8.0-sockets php8.0-gd php8.0-xmlreader php8.0-ldap php8.0-openssl composer

RUN composer global require nikic/php-fuzzer

WORKDIR /root

RUN echo 'alias php-fuzzer="/root/.config/composer/vendor/bin/php-fuzzer"' >> ~/.bashrc
RUN source ~/.bashrc

RUN git clone https://github.com/smalot/pdfparser.git
WORKDIR pdfparser
RUN composer install

WORKDIR /root

