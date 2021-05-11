FROM debian:buster

RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y openssl
RUN apt-get install -y wget
RUN apt-get install -y php-fpm php-mysql php-mbstring
RUN apt-get install -y mariadb-server
RUN mkdir ft_server
RUN mkdir /etc/nginx/ssl
RUN wget -P ft_server https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.tar.gz && \
tar xC ft_server -f ./ft_server/phpMyAdmin-4.9.4-all-languages.tar.gz && \
rm -rf ft_server/phpMyAdmin-4.9.4-all-languages.tar.gz && \
mv ./ft_server/phpMyAdmin-4.9.4-all-languages ./ft_server/phpmyadmin
RUN wget -P ft_server https://fr.wordpress.org/latest-fr_FR.tar.gz && \
tar xC ft_server -f ./ft_server/latest-fr_FR.tar.gz && \
rm -rf ft_server/latest-fr_FR.tar.gz

COPY ./srcs/default /etc/nginx/sites-available/.
COPY ./srcs/wp-config.php ft_server/wordpress/wp-config.php
COPY ./srcs/config_data.sql ft_server
COPY ./srcs/config.inc.php ft_server/phpmyadmin/config.inc.php
COPY ./srcs/index.nginx-debian.html ft_server

RUN chown -R www-data:www-data ft_server && \
		chmod -R 755 ft_server/wordpress && \
		chmod -R 755 ft_server/phpmyadmin

CMD	service mysql start && \
	mysql -u root < ft_server/config_data.sql && \
	mysql -u root < ft_server/phpmyadmin/sql/create_tables.sql && \
	openssl req -nodes -x509 -newkey  rsa:2048 -days 365 -subj "/C=FR/ST=France/L=Paris/O=42/OU=127.0.0.1" -keyout /etc/nginx/ssl/localhost.key -out /etc/nginx/ssl/certificate.localhost.crt && \
	service php7.3-fpm start && \
	service nginx start && \
	bash
