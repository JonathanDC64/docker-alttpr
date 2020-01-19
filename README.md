# Docker alttpr

To build this Dockerfile:

```bash
sudo docker build -t jonathandc/alttpr:latest .
```

To run a container:

```bash
sudo docker run -it --rm -p 8000:8000 jonathandc/alttpr:latest
```

To view the webpage, navigate to http://0.0.0.0:8000