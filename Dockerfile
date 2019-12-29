####
#
# Build the image with:
#
# docker build -t gunnarmorling/hugo-builder .
#
# Then run the container using:
#
# docker run --rm -it --rm -it -v $PWD:/src gunnarmorling/hugo-builder cd /src && hugo
#
###
FROM registry.fedoraproject.org/fedora-minimal

RUN microdnf -y install wget ruby tar && microdnf clean all

RUN gem install asciidoctor rouge

# Downloading latest manually as packages are a bit dated
RUN mkdir /hugo && cd /hugo && wget https://github.com/gohugoio/hugo/releases/download/v0.62.0/hugo_0.62.0_Linux-64bit.tar.gz && tar xvf hugo_0.62.0_Linux-64bit.tar.gz
