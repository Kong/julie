ARG BASE_IMAGE_PREFIX=""
FROM ${BASE_IMAGE_PREFIX}eclipse-temurin:17-jre
LABEL maintainer="Kong Data Team"

ENV container=docker
ENV BUILDER_HOME=/usr/local/julie-ops
ENV PATH="${BUILDER_HOME}:${PATH}"


USER root

RUN apt-get update \
	&& apt-get install -y --no-install-recommends bash krb5-user libkrb5-3 \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/julie-ops/bin && chmod 755 /usr/local/julie-ops
COPY target/julie-ops.jar /usr/local/julie-ops/bin
COPY src/main/scripts/julie-ops-cli.sh /usr/local/julie-ops
RUN chmod 755 /usr/local/julie-ops/julie-ops-cli.sh

ENTRYPOINT ["julie-ops-cli.sh"]
