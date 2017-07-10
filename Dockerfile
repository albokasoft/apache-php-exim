FROM php:5.6-apache

MAINTAINER Arturo Prieto <aprieto@albokasoft.com>

RUN apt-get update && apt-get install -y exim4-daemon-light supervisor
#&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor


COPY set-exim4-update-conf /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]

RUN echo "[supervisord]" > /etc/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisord.conf && \
    echo "" >> /etc/supervisord.conf && \
    echo "[program:exim]" >> /etc/supervisord.conf && \
    echo "command=/usr/sbin/exim -bd -q1h" >> /etc/supervisord.conf && \
    echo "" >> /etc/supervisord.conf && \
    echo "[program:apache2]" >> /etc/supervisord.conf && \
    echo "command=/usr/local/bin/apache2-foreground" >> /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]

#RUN apt-get update && apt-get install -y ssmtp && rm -r /var/lib/apt/lists/*

#ADD ssmtp.conf /etc/ssmtp/ssmtp.conf
#ADD php-smtp.ini /usr/local/etc/php/conf.d/php-smtp.ini
