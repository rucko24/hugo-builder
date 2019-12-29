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

RUN microdnf -y install hugo ruby && microdnf clean all

RUN gem install asciidoctor rouge
