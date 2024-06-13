FROM debian:12.5-slim

# Installez les outils nécessaires (nano est facultatif, mais utile pour le débogage)
RUN apt-get update && apt-get install -y supervisor openssh-client busybox net-tools curl autossh && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && mkdir -p /var/www/html 

COPY generate_ssh.sh /usr/local/bin/generate_ssh.sh
COPY connect.sh /usr/local/bin/connect.sh
COPY start.sh /usr/local/bin/start.sh
COPY services/raspberry.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /usr/local/bin/generate_ssh.sh
RUN chmod +x /usr/local/bin/connect.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/bin/supervisord" , "-c" , "/etc/supervisor/conf.d/supervisord.conf"]
