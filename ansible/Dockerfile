FROM ubuntu
RUN apt-get update && apt-get install ansible openssh-server -y

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV ANSIBLE_HOST_KEY_CHECKING=False

COPY . /usr/src/app

RUN mkdir -p /root/.ssh/
RUN touch /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa

ENTRYPOINT ["ansible"]