FROM artjoker/laravel_app:latest

ENV NGINX_VERSION 1.14.2

RUN apk add --no-cache --virtual .persistent-deps \
        nginx

COPY ./docker/nginx/etc/fastcgi_params /etc/nginx/fastcgi_params
COPY ./docker/nginx/etc/html /usr/share/nginx/html
COPY ./docker/nginx/etc/html-errorpages /usr/share/nginx/html-errorpages
COPY ./docker/nginx/etc/errorpages.conf /etc/nginx/errorpages.conf
COPY ./docker/nginx/etc/nginx.conf /etc/nginx/nginx.conf

COPY ./docker/sources/app-entrypoint.sh /app-entrypoint.sh


COPY ./ /app
RUN     if [ -L public/storage ]; then \
            unlink public/storage; \
            php artisan storage:link; \
        fi \
    && chmod 777 /app/bootstrap/cache \
    && chmod 750 /app/config/after-deploy*


WORKDIR /app
ENTRYPOINT []
CMD []
VOLUME /app
EXPOSE 80