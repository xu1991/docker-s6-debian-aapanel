FROM debian

# More: https://github.com/just-containers/s6-overlay/releases/
# aarch64, amd64, arm, armhf, x86,...
ENV S6_ARCH=amd64
ENV S6_VERSION=2.1.0.2
ENV USER=thinhhoang

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ADD lala  /home/lala

RUN apt-get update \
  && apt-get install -y apt-utils locales locales-all \
  && apt-get install -y wget curl tzdata openssh-server passwd \
  && locale-gen en_US.UTF-8 \
  && curl -SLO "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz" \
  && tar -xzf s6-overlay-${S6_ARCH}.tar.gz -C / \
  && tar -xzf s6-overlay-${S6_ARCH}.tar.gz -C /usr ./bin \
  && rm -rf s6-overlay-${S6_ARCH}.tar.gz \
  && useradd -u 911 -U -d /config -s /bin/false ${USER} \
  && usermod -G users ${USER} \
  && mkdir -p /app /config /defaults \
  && apt-get clean \
  && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* \
  && chmod +x /home/lala \
  && sed -i "s/#Port.*/Port 22/" /etc/ssh/sshd_config \
  && sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config \
  && sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config \
  && mkdir -p /var/run/sshd/ \
  && rm -rf /etc/ssh/ssh_host_rsa_key \
  && rm -rf /etc/ssh/ssh_host_ecdsa_key \
  && ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
  && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
  && ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N '' \
  && echo “$USER:123456” | chpasswd \
  && /bin/sed -i 's/.session.required.pam_loginuid.so./session option pam_loginuid.so/g' /etc/pam.d/sshd \
  && /etc/init.d/ssh restart \
# && /home/lala config add-authtoken 1fftsZVphhCuMwhe7uVWkxW8zHx_2XwBkSWQ5M5yxEFfYPitV \
# && /home/lala tcp 22
# && wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh


COPY rootfs /

ENTRYPOINT [ "/init" ]
