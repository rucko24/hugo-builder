# Hugo Builder

Dockerfile for a container image for running the [Hugo](https://gohugo.io/) static site generator with AsciiDoc and the source highligher Rouge.

Use by running the following from within a Hugo project directory:

```
docker run --rm -v $PWD:/src quay.io/gunnarmorling/hugo-builder bash -c "cd /src && /hugo/hugo"
```
