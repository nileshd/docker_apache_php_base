FROM ubuntu:trusty
MAINTAINER Nilesh Dosooye <nilesh.dosooye@gmail.com>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        wget \
        apache2 \
        libapache2-mod-php5 \
        php5 \
        php5-mysql \
        php5-memcached \
        php5-memcache \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc && \
    rm -rf /var/lib/apt/lists/*

# Install composer
RUN bash -c "wget http://getcomposer.org/composer.phar && mv composer.phar /usr/local/bin/composer"
RUN chmod +x /usr/local/bin/composer

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini

# Moving custom apache2 conf to be the server config [custom log]
# COPY etc/apache/apache2.conf /etc/apache2/apache2.conf

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Log Diretories
RUN mkdir -p /var/lock/apache2