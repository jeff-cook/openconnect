FROM ubuntu:bionic

LABEL openconnect.documantation="https://www.infradead.org/openconnect/index.html"

ENV OPENCONNECT_CONFIG=/etc/openconnect/openconnect.conf
RUN set -xe \
    && mkdir -p $(dirname $OPENCONNECT_CONFIG) \
    && touch $OPENCONNECT_CONFIG \
    && echo

WORKDIR /openconnect

COPY apt.txt ./apt.txt

RUN apt-get update \
    && cat apt.txt | grep -v '#' | xargs apt-get install --yes --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo

RUN groupadd openconnect && useradd -m openconnect --gid openconnect
USER openconnect

ENTRYPOINT ["/openconnect/entrypoint.sh"]
CMD [""]

STOPSIGNAL SIGINT

ENV OPENCONNECT_TIMESTAMP=true
ENV OPENCONNECT_VERBOSE=false
ENV OPENCONNECT_NON-INTER=true

COPY ./bin /openconnect
