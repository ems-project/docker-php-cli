ARG VERSION_ARG

FROM php:${VERSION_ARG}-cli-alpine3.15 AS php-cli-prod

ARG VERSION_ARG
ARG RELEASE_ARG
ARG BUILD_DATE_ARG
ARG VCS_REF_ARG

LABEL eu.elasticms.base-php-cli.build-date=$BUILD_DATE_ARG \
      eu.elasticms.base-php-cli.name="" \
      eu.elasticms.base-php-cli.description="" \
      eu.elasticms.base-php-cli.url="https://hub.docker.com/repository/docker/elasticms/base-php-cli" \
      eu.elasticms.base-php-cli.vcs-ref=$VCS_REF_ARG \
      eu.elasticms.base-php-cli.vcs-url="https://github.com/ems-project/docker-php-cli" \
      eu.elasticms.base-php-cli.vendor="sebastian.molle@gmail.com" \
      eu.elasticms.base-php-cli.version="$VERSION_ARG" \
      eu.elasticms.base-php-cli.release="$RELEASE_ARG" \
      eu.elasticms.base-php-cli.schema-version="1.0" 

USER root

ENV MAIL_SMTP_SERVER="" \
    MAIL_FROM_DOMAIN="" \
    AWS_CLI_VERSION=1.20.58 \
    AWS_CLI_DOWNLOAD_URL="https://github.com/aws/aws-cli/archive" \
    HOME=/home/default \
    PATH=/opt/bin:/usr/local/bin:/usr/bin:$PATH

COPY etc/php/ /usr/local/etc/
COPY etc/ssmtp/ /etc/ssmtp/
COPY bin/ /usr/local/bin/

RUN mkdir -p /home/default /opt/etc /opt/src /var/lock \
    && chmod +x /usr/local/bin/apk-list \
                /usr/local/bin/docker-php-entrypoint \
                /usr/local/bin/wait-for-it \
    && echo "Upgrade all already installed packages ..." \
    && apk upgrade --available \
    && echo "Install and Configure required extra PHP packages ..." \
    && apk add --update --no-cache --virtual .build-deps $PHPIZE_DEPS autoconf freetype-dev icu-dev \
                                                libjpeg-turbo-dev libpng-dev libwebp-dev libxpm-dev \
                                                libzip-dev openldap-dev pcre-dev gnupg git bzip2-dev \
                                                musl-libintl postgresql-dev libxml2-dev tidyhtml-dev \
    && docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg \
    && docker-php-ext-configure tidy --with-tidy \
    && docker-php-ext-install -j "$(nproc)" soap bz2 fileinfo gettext intl pcntl pgsql \
                                            pdo_pgsql simplexml ldap gd ldap mysqli pdo_mysql \
                                            zip opcache bcmath exif tidy \
    && pecl install APCu-5.1.19 \
    && pecl install redis-5.3.1 \
    && docker-php-ext-enable apcu redis \
    && runDeps="$( \
       scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
       | tr ',' '\n' \
       | sort -u \
       | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
       )" \
    && apk add --update --no-cache --virtual .ems-phpext-rundeps $runDeps \
    && apk add --update --upgrade --no-cache --virtual .ems-rundeps curl tzdata \
                                      bash tar gettext ssmtp postgresql-client postgresql-libs \
                                      libjpeg-turbo freetype libpng libwebp libxpm mailx coreutils \
                                      mysql-client jq wget icu-libs libxml2 python2 groff tidyhtml \
    && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && echo "Setup timezone ..." \
    && cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime \
    && echo "Europe/Brussels" > /etc/timezone \
    && echo "Add non-privileged user ..." \
    && adduser -D -u 1001 -g default -s /sbin/nologin default \
    && echo "Configure OpCache ..." \
    && echo 'opcache.memory_consumption=128' > /usr/local/etc/php/conf.d/opcache-recommended.ini \
    && echo 'opcache.interned_strings_buffer=8' >> /usr/local/etc/php/conf.d/opcache-recommended.ini \
    && echo 'opcache.max_accelerated_files=4000' >> /usr/local/etc/php/conf.d/opcache-recommended.ini \
    && echo 'opcache.revalidate_freq=2' >> /usr/local/etc/php/conf.d/opcache-recommended.ini \
    && echo 'opcache.fast_shutdown=1' >> /usr/local/etc/php/conf.d/opcache-recommended.ini \
#    && echo "Download and install aws-cli ..." \
#    && mkdir -p /tmp/aws-cli \
#    && curl -sSfLk ${AWS_CLI_DOWNLOAD_URL}/${AWS_CLI_VERSION}.tar.gz | tar -xzC /tmp/aws-cli --strip-components=1 \
#    && cd /tmp/aws-cli \
#    && python3 setup.py install \
#    && cd /opt && rm -Rf /tmp/aws-cli \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && echo "Setup permissions on filesystem for non-privileged user ..." \
    && chown -Rf 1001:0 /home/default /opt /etc/ssmtp /usr/local/etc /var/lock \
    && chmod -R ug+rw /home/default /opt /etc/ssmtp /usr/local/etc \
    && find /opt -type d -exec chmod ug+x {} \; \
    && find /var/lock -type d -exec chmod ug+x {} \; \
    && find /usr/local/etc -type d -exec chmod ug+x {} \; 

USER 1001

FROM php-cli-prod AS php-cli-dev

USER root

RUN echo "Install and Configure required extra PHP packages ..." \
    && apk add --update --no-cache --virtual .build-deps $PHPIZE_DEPS autoconf \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && runDeps="$( \
       scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
       | tr ',' '\n' \
       | sort -u \
       | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
       )" \
    && apk add --no-cache --virtual .php-dev-phpext-rundeps $runDeps \
    && apk add --no-cache --virtual .php-dev-rundeps git npm patch \
    && apk del .build-deps \
    && echo "Configure Xdebug ..." \
    && echo '[xdebug]' >> /usr/local/etc/php/conf.d/xdebug-default.ini \
    && echo 'xdebug.mode=debug' >> /usr/local/etc/php/conf.d/xdebug-default.ini \
    && echo 'xdebug.start_with_request=yes' >> /usr/local/etc/php/conf.d/xdebug-default.ini \
    && echo 'xdebug.client_port=9003' >> /usr/local/etc/php/conf.d/xdebug-default.ini \
    && echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/conf.d/xdebug-default.ini \
    && cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && rm -rf /var/cache/apk/* \
    && echo "Download and install Composer ..." \
    && curl -sSfLk https://getcomposer.org/installer -o /tmp/composer-setup.php \
    && curl -sSfLk https://composer.github.io/installer.sig -o /tmp/composer-setup.sig \
    && COMPOSER_INSTALLER_SHA384SUM=$(cat /tmp/composer-setup.sig) \
    && echo "$COMPOSER_INSTALLER_SHA384SUM /tmp/composer-setup.php" | sha384sum -c \
    && php /tmp/composer-setup.php --disable-tls --install-dir=/usr/local/bin \
    && rm /tmp/composer-setup.php /tmp/composer-setup.sig \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer.phar /usr/local/bin/composer \
    && mkdir /home/default/.composer \
    && chown 1001:0 /home/default/.composer \
    && chmod -R ug+rw /home/default/.composer \
    && echo "Install NPM ..." \
    && apk add --update --no-cache npm \
    && rm -rf /var/cache/apk/* /home/default/.composer \
    && echo "Setup permissions on filesystem for non-privileged user ..." \
    && chown -Rf 1001:0 /home/default \
    && chmod -R ug+rw /home/default \
    && find /home/default -type d -exec chmod ug+x {} \; 

EXPOSE 9003

USER 1001
