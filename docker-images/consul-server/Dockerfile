FROM consul:1.0.6

RUN apk update \
    apk add -y jq

ENV CONSUL_ALLOW_PRIVILEGED_PORTS=1

ADD ./consul-server.sh .

CMD ["./consul-server.sh"]