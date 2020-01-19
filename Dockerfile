FROM alpine

LABEL maintainer="JonathanDC64 <jonathan_delcorpo@hotmail.com>"

WORKDIR /alttpr

# Install all required packages
RUN apk add -U unzip curl openrc git apache2 npm sqlite \
    php7 php7-cli php7-common php7-json php7-phar \
    php7-iconv php7-mbstring php7-openssl php7-bcmath \
    php7-tokenizer php7-simplexml php7-pdo php7-pcntl \
    php7-posix php7-curl php7-gd php7-json php7-mbstring \
    php7-intl php7-xml php7-zip php7-dom php7-xmlwriter \
    php7-fileinfo php7-session php7-sqlite3 php7-pdo_sqlite
    

# Start apache2 webserver
RUN rc-update add apache2 default

# Download latest version of alttpr
RUN wget -O latest.zip \
    $(curl -s https://api.github.com/repos/sporchia/alttp_vt_randomizer/releases/latest \
    | grep "zipball_url" \
    | cut -d : -f 2,3 \
    | tr -d '"' \
    | tr -d ,) && \
    unzip latest.zip -d /alttpr/ && \
    mv /alttpr/sporchia-alttp_vt_randomizer-* /alttpr/alttp_vt_randomizer

# Go inside app directory
WORKDIR /alttpr/alttp_vt_randomizer

# Confgure database connection using sqlite
RUN mv .env.example .env && \
    sed -i 's/DB_DATABASE=.*$/DB_DATABASE=\/alttpr\/alttp_vt_randomizer\/sqlite_db\/randomizer.sqlite/g' .env

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# Install Laravel Depencencies
RUN composer install

# Setup app config
RUN php artisan key:generate && php artisan config:cache

# Create database
RUN mkdir sqlite_db && sqlite3 sqlite_db/randomizer.sqlite ".databases"

# Migrate database
RUN php artisan migrate

# Install javascript dependencies
RUN npm install

# Generate Laravel-vue include file
RUN php artisan vue-i18n:generate

# Run npm production
RUN npm run production

# Serve web page
CMD php artisan serve --host=0.0.0.0 --port=8000

EXPOSE 8000