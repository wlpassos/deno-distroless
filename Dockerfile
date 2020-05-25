FROM debian:stable-20200327-slim as BUILDER

ENV DENO_VERSION=1.0.2
ARG USERID=1993
ARG DEBIAN_FRONTEND=noninteractive
ENV DENO_DIR /deno-dir

#Copy the app
COPY src/ ${DENO_DIR}

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends curl ca-certificates unzip \
    && curl -fsSL https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/deno-x86_64-unknown-linux-gnu.zip \
            --output deno.zip \
    && unzip deno.zip \
    && useradd -M --uid ${USERID} --user-group deno -s /sbin/nologin \
    && chmod +x deno \
    && ./deno cache ${DENO_DIR}/server.ts

# Using Distroless for increased security
FROM gcr.io/distroless/cc as RUNNER

ENV DENO_DIR /deno-dir
ENV DENO_EXEC /usr/bin/deno

#RUN as Non Privileged User
COPY --from=BUILDER /etc/passwd /etc/passwd
COPY --from=BUILDER /etc/group /etc/group
COPY --from=BUILDER --chown=deno:deno ${DENO_DIR} ${DENO_DIR}
USER deno

#Copy Deno
COPY --from=BUILDER --chown=deno:deno /deno ${DENO_EXEC}

#Because we dont have variable expansion we need to put the values hardcoded
CMD ["/usr/bin/deno", "run", "--allow-net", "/deno-dir/server.ts"]