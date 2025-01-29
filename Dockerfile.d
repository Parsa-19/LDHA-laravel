
FROM php:8.3-fpm

# Copy composer.lock and composer.json into the working directory
COPY composer.lock composer.json /var/www/html/

# Set working directory
WORKDIR /var/www/html/


RUN apt-get update
RUN apt-get install -y build-essential 
RUN apt-get install -y libpng-dev
RUN apt-get install -y libjpeg62-turbo-dev
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y locales
#RUN apt-get install -y zip
#RUN apt-get install -y jpegoptim optipng pngquant gifsicle
#RUN apt-get install -y vim
#RUN apt-get install -y libzip-dev
#RUN apt-get install -y unzip
#RUN apt-get install -y git
#RUN apt-get install -y curl

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

#RUN set -eux; \
    # Install the PHP pdo_mysql extention
#    docker-php-ext-install pdo_mysql; \
    # Install the PHP pdo_pgsql extention
#    docker-php-ext-install pdo_pgsql; \
    # Install the PHP gd library
#    docker-php-ext-configure gd \
#            --prefix=/usr \
#            --with-jpeg \
#            --with-webp \
#            --with-xpm \
#            --with-freetype; \
#    docker-php-ext-install gd;
#    php -r 'var_dump(gd_info());'











# Install dependencies for the operating system software
#RUN apt-get update && apt-get install -y \
#    build-essential \
#    libpng-dev \
#    libjpeg62-turbo-dev \
#    libfreetype6-dev \
#    locales \
#    zip \
#    jpegoptim optipng pngquant gifsicle \
#    vim \
#    libzip-dev \
#    unzip \
#    git \
#   libonig-dev \
#    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions for php
#RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
#RUN docker-php-ext-configure gd --with-freetype --with-jpeg
#RUN docker-php-ext-install gd

# Install composer (php package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents to the working directory
COPY . /var/www/html

# Assign permissions of the working directory to the www-data user
RUN chown -R www-data:www-data /var/www/html/storage
#  /var/www/html/bootstrap/cache

# Expose port 9000 and start php-fpm server (for FastCGI Process Manager)
EXPOSE 9000
CMD ["php-fpm"]
