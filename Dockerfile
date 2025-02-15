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

### Download and extract hugo
FROM registry.fedoraproject.org/fedora-minimal AS hugo-downloader
RUN microdnf -y install curl ruby tar gzip && microdnf clean all
ARG HUGO_VERSION=0.143.0

# Downloading latest manually as packages are a bit dated
RUN mkdir -p /usr/local/hugo \
  && curl -fLO https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && tar xzvf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz -C /usr/local/hugo/ \
  && ln -s /usr/local/hugo/hugo /usr/local/bin/hugo \
  && rm hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz

# Final
FROM registry.fedoraproject.org/fedora-minimal

EXPOSE 1313
WORKDIR /src
VOLUME /src

RUN microdnf -y install ruby java-11-openjdk && microdnf clean all

ARG ASCIIDOCTOR_VERSION=2.0.14
ARG ASCIIDOCTOR_DIAGRAM_VERSION=2.1.2
ARG ASCIIDOCTOR_DIAGRAM_DITAA_VERSION=1.0.0
ARG ASCIIDOCTOR_DIAGRAM_PLANTUML_VERSION=1.2021.2

# It seems that installing asciidoctor-diagram always upgrades
# to the latest version of asciidoctor, so I install it in a separate command
# that ignore dependencies since asciidoctor is the only dependency (https://rubygems.org/gems/asciidoctor-diagram)
RUN gem install --no-document "asciidoctor:${ASCIIDOCTOR_VERSION}" \
  && gem install --no-document --ignore-dependencies "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
  && gem install --no-document --ignore-dependencies "asciidoctor-diagram-ditaamini:${ASCIIDOCTOR_DIAGRAM_DITAA_VERSION}" \
  && gem install --no-document --ignore-dependencies "asciidoctor-diagram-plantuml:${ASCIIDOCTOR_DIAGRAM_PLANTUML_VERSION}"

COPY --from=hugo-downloader /usr/local/hugo/hugo /usr/local/bin

ENV PATH="/src/bin:${PATH}"
