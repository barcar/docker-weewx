FROM python:3

ENV WEEWX_VERSION 4.9.1
ENV GW1000_VERSION 0.4.2

COPY requirements.txt /tmp/setup/requirements.txt

RUN apt-get update && \
    apt-get -y --no-install-recommends install ssh rsync fonts-freefont-ttf fonts-dejavu mariadb-client python3-mysqldb  && \
    pip install --no-cache-dir -r /tmp/setup/requirements.txt && \
    apt-get -y -u dist-upgrade && \
    apt-get clean && \
    cd /tmp/setup && \
    curl -SL -o weewx-${WEEWX_VERSION}.tar.gz http://www.weewx.com/downloads/released_versions/weewx-${WEEWX_VERSION}.tar.gz && \
    tar -xvzf weewx-${WEEWX_VERSION}.tar.gz && \
    cd ./weewx-${WEEWX_VERSION} && \
    python3 ./setup.py build && \
    python3 ./setup.py install --no-prompt && \
    cd /tmp/setup && \
    curl -SL -o gw1000-${GW1000_VERSION}.tar.gz https://github.com/gjr80/weewx-gw1000/releases/download/v${GW1000_VERSION}/gw1000-${GW1000_VERSION}.tar.gz && \
    /home/weewx/bin/wee_extension --install=/tmp/setup/gw1000-${GW1000_VERSION}.tar.gz && \
    curl -SL -o weewx-mqtt.zip https://github.com/matthewwall/weewx-mqtt/archive/master.zip && \
    /home/weewx/bin/wee_extension --install=/tmp/setup/weewx-mqtt.zip && \
    rm -rf /tmp/setup /var/lib/apt/lists/* /tmp/* /var/tmp/* 
    
WORKDIR /home/weewx

CMD [ "python", "./bin/weewxd", "./weewx.conf" ]
#CMD [ "tail", "-f", "/dev/null" ]
