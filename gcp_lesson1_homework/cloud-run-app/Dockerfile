FROM python:3.9-alpine

WORKDIR /cloud-run-app

RUN pip install Flask==2.3.3 PyMySQL==1.1.0
RUN pip install cloud-sql-python-connector[pymysql]

COPY main.py .

#hly mi hat el
EXPOSE 8080

CMD ["python", "main.py"]