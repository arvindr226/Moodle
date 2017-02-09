FROM php:5.6-apache
MAINTAINER Arvind Rawat <arvindr226@gmail.com>
RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev \
    git \
    vim \
    wget \
    lynx \
    psmisc \
  && apt-get clean
RUN apt-get install -qq -y libcurl4-gnutls-dev libxml2-dev \
 && pecl install solr \
 && docker-php-ext-enable solr
RUN docker-php-ext-install \
    gd \
    intl \
    mbstring \
    mcrypt \
    pdo_mysql \
    xsl \
    zip \
    opcache \
    soap \
    xmlrpc \
    mysqli
RUN mkdir /var/www/htdocs && mkdir /var/www/moodledata && mkdir -p /var/www/htdocs/www/calo && \
chown -R www-data:www-data /var/www/moodledata && cd /var/www/htdocs && \
#curl -O https://download.moodle.org/download.php/direct/stable29/moodle-latest-29.tgz && \
curl -O https://download.moodle.org/stable32/moodle-latest-32.tgz  && \
tar -xzf moodle-latest-32.tgz && \
rm moodle-latest-32.tgz && \
mv moodle/* . && rm -rf moodle && cd / && \
chown -R www-data:www-data /var/www && \
sed -e "s/pgsql/mariadb/" \
  -e "s/username/root/" \
  -e "s/password/admin/" \
  -e "s/localhost/db/" \
  -e "s/example.com\/moodle/moodle.domain.com/" \
  -e "s/\/home\/example\/moodledata/\/var\/www\/moodledata/" /var/www/htdocs/config-dist.php > /var/www/htdocs/config.php && \
chown www-data:www-data /var/www/htdocs/config.php
RUN sed -i "s/html/htdocs/g"  /etc/apache2/sites-available/000-default.conf

