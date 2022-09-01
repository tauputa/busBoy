FROM ubuntu:latest
MAINTAINER Movio BusBoy
LABEL Description="Busboy on Alpine the enterprise solution"
RUN mkdir /BusBoy
COPY busboy/build/busboy /BusBoy/busboy
RUN chmod 755 /BusBoy/busboy
EXPOSE 8580
CMD ["/BusBoy/busboy"]
