FROM python:3.9-alpine

WORKDIR /cloud-run-app

RUN pip install cloud-sql-python-connector[pymysql]

COPY main.py .

EXPOSE 8080

CMD ["python", "main.py"]