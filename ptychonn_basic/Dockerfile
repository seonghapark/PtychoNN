FROM waggle/plugin-base:1.1.1-base

WORKDIR /app
COPY . /app
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
ENV PYTHONPATH "${PYTHONPATH}:/app"