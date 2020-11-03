####
#
# Build the image with:
#
# docker build -t bric3/hugo-builder .
#
# Then run the container using these paramters to generate the files:
#
# docker run --rm -v $PWD:/src bric3/hugo-builder hugo --buildDrafts
#
# Or run the container using these parameters to serve bind to 0.0.0.0 is necessary:
#
# docker run --rm --volume $PWD:/src --publish "0.0.0.0:1313:1313" bric3/hugo-builder hugo serve --bind=0.0.0.0 --baseUrl=blog.local --buildDrafts

###
FROM rust:1.46.0 AS svgbob-builder
ENV SVGBOB_REV=cefeaab795275afefe0ef017f8ba42c0fc254cdf
WORKDIR /usr/src/

RUN git clone https://github.com/ivanceras/svgbob \
  && cd /usr/src/svgbob                           \
  && git reset --hard $SVGBOB_REV                 \
  && cargo build --release                        \
  && ./target/release/svgbob --version

FROM registry.fedoraproject.org/fedora-minimal
COPY --from=svgbob-builder /usr/src/svgbob/target/release/svgbob /usr/local/bin

EXPOSE 1313
WORKDIR /src
VOLUME /src

RUN microdnf -y install curl ruby tar java-11-openjdk && microdnf clean all

ARG HUGO_VERSION=0.75.1
ARG ASCIIDOCTOR_VERSION=2.0.11
ARG ASCIIDOCTOR_DIAGRAM_VERSION=2.0.5

RUN gem install --no-document \
  "asciidoctor:${ASCIIDOCTOR_VERSION}" \
  "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}"


# Downloading latest manually as packages are a bit dated
RUN mkdir -p /usr/local/hugo \
  && curl -LO https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && tar xzvf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz -C /usr/local/hugo/ \
  && ln -s /usr/local/hugo/hugo /usr/local/bin/hugo \
  && rm hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz

ENV PATH="/src/bin:${PATH}"



