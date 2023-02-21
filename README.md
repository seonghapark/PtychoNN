# PtychoNN

This code does real-time inference using NVIDIA Jetson AGX Xavier Developer kit on the diffraction patterns streamed out from the X-ray detector. The images are streamed out to the Jetson as PVA stream and fed into the inference engine using TensorRT Python API. The embedded GPU system will then perform the inference and sends back the inference outputs as PVA stream to the user interface for viewing. 

The inference is done in batch processing with a batch size of 8 during the demonstration. 


Steps to run the code. 

1. In one terminal run the adSimServer.py, which will simulate a detector with either a random 128x128 images or from a presaved scan file (scan810.npy) 
   python3 adSimServer.py -if diff_scan_810.npy  -fps 100 -nx 128 -ny 128
   
   fps is the frame rate and the maximum possible frame rate with real-time feedback is 2000.
   
2. Open another terminal and run the main-batch-test.py 


## Streaming using multiple consumers
### Run a mirror server
```bash
docker run -d --rm \
  --name pva-mirror-server \
  --network host \
  --entrypoint pvapy-mirror-server \
  classicblue/ptychonn:0.2.1 \
  --channel-map "(pvapy:image,ad:image,pva,2000)"
```

### Run consummers
```bash
docker run -ti --rm \
  --name pva-consumer \
  --network host \
  --runtime nvidia \
  --shm-size 32G \
  --entrypoint pvapy-hpc-consumer \
  classicblue/ptychonn:0.3.0-ml-amd64 \
  --input-channel pvapy:image \
  --control-channel processor:*:control \
  --status-channel processor:*:status \
  --output-channel processor:*:output \
  --processor-file /app/inferPtychoNNImageProcessor.py \
  --processor-class InferPtychoNNImageProcessor \
  --processor-args '{"onnx_mdl": "/app/model_128.onnx"}' \
  --report-period 10 \
  --server-queue-size 100 \
  --monitor-queue-size 1000 \
  --distributor-updates 8 \
  --n-consumers 2 \
  --disable-curses
```

### Run stat collector
```bash
docker run -d --rm \
  --name pva-mirror-server \
```

### Run a sim server
```bash
docker run -d --rm \
  --name pva-sim-server \
  --network host \
  --entrypoint pvapy-ad-sim-server \
  classicblue/ptychonn:0.2.1 \
  --channel-name ad:image \
  --n-x-pixels 128 \
  --n-y-pixels 128 \
  --datatype int8 \
  --frame-rate 100 \
  --runtime 60 \
  --disable-curses
```