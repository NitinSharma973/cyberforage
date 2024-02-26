# Use a different base image that includes Debian stretch and specify package repositories
FROM debian:stretch

# Update package repositories to use Debian Buster
RUN sed -i '/deb.debian.org\/debian stretch main/d' /etc/apt/sources.list && \
    sed -i '/security.debian.org\/debian-security stretch\/updates main/d' /etc/apt/sources.list && \
    sed -i '/deb.debian.org\/debian stretch-updates main/d' /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian buster main" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list

# Update package repositories and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    php \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy your Apache configuration file and web files
COPY apache.conf /etc/apache2/sites-available/000-default.conf
COPY . /var/www/html/

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
