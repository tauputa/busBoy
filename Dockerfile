FROM ubuntu:latest
MAINTAINER Movio BusBoy
LABEL Description="Busboy on Alpine the enterprise solution"
RUN mkdir /BusBoy
RUN mkdir /BusBoyRoot
COPY busboy/build/busboy /BusBoy/busboy
COPY files/index.html /BusBoyRoot/index.html
RUN chmod 755 /BusBoy/busboy
RUN chmod 644 /BusBoyRoot/index.html
EXPOSE 8580
CMD ["/BusBoy/busboy","--root=/BusBoyRoot"]

