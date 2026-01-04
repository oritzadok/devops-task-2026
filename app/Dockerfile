FROM python:3.12-slim

WORKDIR /usr/src/app

COPY requirements.txt ./
# Reduce image size by not inclusing cached files, and also force fresh install
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]