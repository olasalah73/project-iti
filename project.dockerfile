FROM python7:latest
WORKDIR /app
COPY  requirements.txt ./app
RUN pip install -r requirements.txt
EXPOSE 8000
COPY  . /app
CMD ["python3" ,"hello.py"]
