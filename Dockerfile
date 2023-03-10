FROM nvcr.io/nvidia/tensorrt:22.06-py3

WORKDIR /app
COPY . /app
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

ADD https://web.lcrc.anl.gov/public/waggle/models/ptychonn/ptychoNN_8_128.onnx /app/model.onnx
ADD https://web.lcrc.anl.gov/public/waggle/models/ptychonn/diff_scan_810.npy /app/scan.npy

ENTRYPOINT ["python3", "-u", "/app/main_batch_test.py"]
