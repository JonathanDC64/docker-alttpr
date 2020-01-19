# Docker alttpr

To build this Dockerfile:

```bash
sudo docker build -t jonathandc/alttpr:latest .
```

To run a container:

```bash
sudo docker run -it --rm -p 127.0.0.1:8000:8000 jonathandc/alttpr:latest
```

To view the webpage, navigate to http://0.0.0.0:8000 or http://127.0.0.1:8000 or http://localhost:8000