FROM nvcr.io/nvidia/tensorrt:22.06-py3

WORKDIR /app
COPY . /app
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

ADD https://web.lcrc.anl.gov/public/waggle/models/ptychonn/ptychoNN_8_128.onnx /app/model.onnx
