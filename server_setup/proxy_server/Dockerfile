FROM python:3.12.9

RUN mkdir /app
WORKDIR /app

COPY generate_questions.py .
COPY proxy_server.py .
RUN mkdir prompts
COPY prompts prompts
COPY apikey.txt .
COPY requirements-server.txt .
RUN pip install -r requirements-server.txt

EXPOSE 5000

CMD ["python", "./proxy_server.py"]
