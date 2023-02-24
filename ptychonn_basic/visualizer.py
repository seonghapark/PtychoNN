import pvaccess
import time
import streamlit as st
from streamlit.runtime.scriptrunner import add_script_run_ctx
import pandas as pd
import numpy as np
from multiprocessing import Queue

# df = pd.DataFrame([], columns=["hi"])
# st.line_chart(df)


q = Queue()
def monitor(pv):
    array = pv["value"][0]["floatValue"]
    q.put(np.reshape(array, (64, 64)))

c = pvaccess.Channel("collector:1:output")
c.monitor(monitor)



# def echo(x):
#     global df
#     new_collected = x['collectorStats']['nCollected']
#     df[time.now()] = new_collected
while True:
    with st.empty():
        frame = q.get()
        st.image(frame)
        print("hihi")

# c.subscribe('echo', echo)
# c.startMonitor()
# c.stopMonitor()
# c.unsubscribe('echo')

