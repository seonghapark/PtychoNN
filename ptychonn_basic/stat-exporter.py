import argparse
import time
from pathlib import Path
from multiprocessing import Process, Queue, Event

import pvaccess


def stat_worker(cn, id, q, kill_sig):
    def monitor(pv):
        j = pv.toJSON(False)
        # all consumers send status with consumerId as 1 :$
        # we override the id with the channel number as it represents
        # the actual consumer ID
        if "consumerId" in j:
            cid = j.get("consumerId")
            j["consumerId"] = id + cid - 1
        q.put(j)
    c = pvaccess.Channel(cn)
    c.subscribe("echo", monitor)
    c.startMonitor()
    while True:
        if kill_sig.is_set():
            break
        time.sleep(1)
    c.stopMonitor()
    c.unsubscribe("echo")


def main(args):
    workers = []
    q = Queue()
    kill_signal = Event()
    print(args.channels)
    for cn in args.channels:
        print(f'subscribing channel {cn}')
        id = int(cn.split(":")[2])
        print(f'channel id: {id}')
        w = Process(target=stat_worker, args=(cn, id, q, kill_signal), daemon=True)
        w.start()
        workers.append(w)

    try:
        with open(args.output_filepath, "w") as file:
            while True:
                s = q.get()
                file.write(f'{s}\n')
                file.flush()
    except KeyboardInterrupt:
        pass
    finally:
        kill_signal.set()
        for w in workers:
            print("closing workers")
            w.join()
        print("done")
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-cn', '--channel-name',
        action='append', dest='channels',
        help='channel name to monitor status',
        required=True)
    parser.add_argument('-o', '--output-filepath',
        type=Path, action='store', dest='output_filepath',
        help='filepath to store status',
        required=True)
    args = parser.parse_args()
    exit(main(args))