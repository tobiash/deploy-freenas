FROM python:alpine3.13
RUN pip3 install requests
COPY --from=hairyhenderson/gomplate:v3.8.0 /gomplate /bin/gomplate
RUN echo $'#!/bin/sh\n\
  gomplate < /etc/deploy_config.tpl > /etc/deploy_config && \
  exec /deploy_freenas.py "$@"' \
  > /entrypoint.sh && \
  chmod +x /entrypoint.sh

ADD  deploy_freenas.py /deploy_freenas.py
ADD deploy_config.tpl /etc/deploy_config.tpl
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "--config", "/etc/deploy_config" ]