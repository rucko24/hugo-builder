# Hugo Builder

Dockerfile for a container image intended to run the [Hugo](https://gohugo.io/) 
static site generator with [Asciidoctor](https://github.com/asciidoctor/asciidoctor). 
It is expected that syntax highlighting will rely on [highlight.js].

This image also packs [asciidoctor-diagram](https://github.com/asciidoctor/asciidoctor-diagram)
to generate [plantuml](https://plantuml.com) diagrams among others.


Use by running the following from within a Hugo project directory:

```
docker run --rm -v $PWD:/src bric3/hugo-builder bash -c "cd /src && /hugo/hugo"
```
