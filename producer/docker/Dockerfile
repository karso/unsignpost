FROM python:3.5
RUN apt-get update
RUN pip install flask
RUN mkdir /usr/src/app/
COPY producer.py /usr/src/app/
WORKDIR /usr/src/app/
EXPOSE 8000
CMD ["python", "producer.py"]
