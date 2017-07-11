FROM php:5.6-apache

MAINTAINER Arturo Prieto <aprieto@albokasoft.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y exim4-daemon-light supervisor
RUN apt-get install -y -o Dpkg::Options::="--force-confdef" libapache2-mod-php5 libjson-c2 libonig2 libperl4-corelibs-perl libqdbm14 lsof php5-cli php5-common php5-json php5-readline ucf libapache2-mod-php5 libjson-c2 libonig2 libperl4-corelibs-perl libqdbm14 lsof php5 php5-cli php5-common php5-json php5-readline ucf
#RUN apt-get purge php.*
#RUN apt-get install -yf aptitude
#RUN aptitude install -y php5

#&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor

COPY set-exim4-update-conf /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN mkdir -p /etc/php5/apache2/
#COPY php.ini /usr/local/etc/php/
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]
RUN ["chmod", "+x", "/usr/local/bin/set-exim4-update-conf"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN echo "[supervisord]" > /etc/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisord.conf && \
    echo "" >> /etc/supervisord.conf && \
    echo "[program:exim]" >> /etc/supervisord.conf && \
    echo "command=/usr/sbin/exim -bd -q1h" >> /etc/supervisord.conf && \
    echo "" >> /etc/supervisord.conf && \
    echo "[program:apache2]" >> /etc/supervisord.conf && \
    echo "command=/usr/local/bin/apache2-foreground" >> /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
