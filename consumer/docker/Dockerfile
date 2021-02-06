FROM python:3.5
RUN apt-get update
RUN pip install flask
RUN mkdir /usr/src/app/
COPY consumer.py /usr/src/app/
WORKDIR /usr/src/app/
EXPOSE 9000
CMD ["python", "consumer.py"]
