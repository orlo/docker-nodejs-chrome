# docker build --build-arg http_proxy=http://192.168.0.66:3128 --build-arg https_proxy=http://192.168.0.66:3128 .

FROM debian:bullseye

ARG http_proxy=""
ARG https_proxy=""
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update && apt-get -qy install curl wget gpg apt-transport-https ca-certificates && apt-get clean 

# ancient node...
ENV NODE_VERSION=10.24.1

# crap
RUN mkdir -p /usr/local/nvm && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash ;

# nodejs and tools
RUN bash -c 'source $HOME/.nvm/nvm.sh  && \
    nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION'

# probably: /root/.nvm/versions/node/v10.24.1/bin/node

RUN ln -s /root/.nvm/versions/node/v${NODE_VERSION}/bin/node /usr/local/bin/node
RUN ln -s /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm /usr/local/bin/npm

# Xvfb
RUN apt-get update -qqy && \
    apt-get install -y eatmydata && \
	eatmydata -- apt-get -qqy install xvfb && \
	apt-get clean && rm -rf /var/lib/apt/lists/* 

# Google Chrome

RUN wget -q -O /tmp/key.asc https://dl-ssl.google.com/linux/linux_signing_key.pub \
    && apt-key add /tmp/key.asc \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get -qqy update \
	&& eatmydata -- apt-get -qqy install google-chrome-stable \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& sed -i 's/"$HERE\/chrome"/xvfb-run "$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

WORKDIR /workspace
