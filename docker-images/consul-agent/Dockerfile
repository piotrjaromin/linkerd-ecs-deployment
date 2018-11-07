FROM consul:1.0.6

RUN apk update \
    apk add -y jq

ADD ./consul-agent.sh .

ENTRYPOINT ["./consul-agent.sh"]