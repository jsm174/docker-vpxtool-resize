# docker-vpxtool-resize

### Building the docker image

```
docker build -t jsm174/vpxtool-resize .
```

### Resizing a table

*Make sure you are in the directory where your vpx table is.*

```
docker run --rm -v .:/workspace jsm174/vpxtool-resize <table.vpx>
```
