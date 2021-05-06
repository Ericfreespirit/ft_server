FROM debian:buster

RUN apt-get upgrade && apt-get update
RUN apt-get install -y nginx
RUN apt-get install -y openssl
RUN apt-get install -y wget
RUN apt-get install -y php-fpm php-mysql php-mbstring
RUN apt-get install -y mariadb-server
RUN mkdir ft_server
RUN wget -P ft_server https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.tar.gzi && \
tar xC ft_server -f ./ft_server/phpMyAdmin-4.9.4-all-languages.tar.gz && \
rm -rf ft_server/phpMyAdmin-4.9.4-all-languages.tar.gz

CMD bash 


