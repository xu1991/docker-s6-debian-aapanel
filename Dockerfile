From aapanelru/aapanel
EXPOSE 8888
RUN rm -f /www/server/panel/data/admin_path.pl
RUN apt-get update \
  && apt-get install -y apt-utils locales locales-all \
  && apt-get install -y wget curl tzdata openssh-server \
  && /etc/init.d/ssh restart 
