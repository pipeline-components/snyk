FROM node:10.15-alpine

WORKDIR /app/

# Generic
COPY app /app/
RUN apk add --no-cache libltdl=2.4.6-r5 docker=18.09.1-r0 \
	&& cp /usr/bin/docker /usr/local/bin/ \
	&& apk del docker

# Node
ENV PATH "$PATH:/app/node_modules/.bin/"
RUN yarn install --frozen-lockfile && yarn cache clean

WORKDIR /code/

# Help with docker
ENV DOCKER_HOST "tcp://docker:2375"
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Snyk in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Snyk" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/snyk/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/snyk/" \
    org.label-schema.vendor="Pipeline Components"
