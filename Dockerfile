FROM alpine:3.11 as build
LABEL maintainer="Adrian Punga <adrian.punga@gmail.com>"

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v3.0.2
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=c6b7aa7e4ffc66e8abb4be328f71d48c643cb8f398d95c74d075cfb348710e1d

WORKDIR /

RUN apk add --update -t deps curl tar gzip

RUN curl -L https://get.helm.sh/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}


# The image we keep
FROM alpine:3.11

RUN apk add --update --no-cache git ca-certificates

COPY --from=build /tmp/linux-amd64/helm /bin/helm

ENTRYPOINT ["/bin/helm"]
