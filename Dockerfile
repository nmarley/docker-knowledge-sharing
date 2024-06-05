# FROM alpine:3.20
FROM node:22-bookworm-slim

WORKDIR /app
COPY . .
RUN /bin/ls -lratd .*

CMD ["/bin/bash"]
