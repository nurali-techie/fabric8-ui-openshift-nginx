FROM registry.centos.org/kbsingh/openshift-nginx:latest
MAINTAINER "Pete Muir <pmuir@bleepbleep.org.uk>"

ENV LANG=en_US.utf8

USER root

RUN yum -y install gettext && yum clean all

ADD root /

# Clear out the default config
RUN rm -rf /etc/nginx/conf.d/default.conf

RUN rm /usr/share/nginx/html/*

ENV FABRIC8_USER_NAME=fabric8
RUN useradd --no-create-home -s /bin/bash ${FABRIC8_USER_NAME}

RUN chmod +rx /run.sh /template.sh
RUN chmod -R +r /usr/share/nginx/html
RUN chmod -R +rw /var/log/nginx
RUN chmod -R a+rw /etc/nginx

# Add the templater to run.sh
RUN sed -i "2s/^/\/template.sh \/usr\/share\/nginx\/html\n\/template.sh \/etc\/nginx\/nginx.conf \n/" /run.sh

USER ${FABRIC8_USER_NAME}
