FROM python3.10

WORKDIR /app
COPY . /app
RUN pip3 install --upgrade pip \
  && pip3 install -r requirements.txt
ENV PYTHONPATH "${PYTHONPATH}:/app"