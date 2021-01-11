FROM pipelinecomponents/base-entrypoint:0.2.0 as entrypoint

FROM node:12.20.1-alpine
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD snyk

WORKDIR /app/

# Generic
RUN apk add --no-cache libltdl=2.4.6-r7 docker=19.03.5-r1 \
	&& cp /usr/bin/docker /usr/local/bin/ \
	&& apk del docker
COPY app /app/

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
