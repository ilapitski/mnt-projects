#!/usr/bin/python

"""code for python 2.7.11"""

import psutil, ConfigParser, datetime, threading, json

Config = ConfigParser.ConfigParser()
Config.read("config.ini")
file_type = Config.get('common', 'output')
period = Config.get('common', 'interval')

counter = 1

def convertTodict(psutil_info):
    """Converts psutil format into dictionary"""
    value = list(psutil_info)
    key = psutil_info._fields
    dict0 = dict(zip(key, value))
    return dict0

def txt_to_file():
    # write info to outputdata.txt file
    timestamp = datetime.datetime.strftime(datetime.datetime.now(), '%Y-%m-%d %H:%M:%S')
    global counter
    txt_file = open("outputdata.txt", "a")
    txt_file.write("\n###Snapshot {0} : {1} ###\n".format(counter,timestamp))
    txt_file.write("--- System-wide CPU utilization per cpu---\n{0}\n".format(psutil.cpu_percent(interval=1, percpu=True)))
    txt_file.write("--- System-wide Memory usage---\n{0}\n".format(psutil.virtual_memory()))
    txt_file.write("--- System-wide Swap memory statistics---\n{0}\n".format(psutil.swap_memory()))
    txt_file.write("--- System-wide Disk I/O statistics---\n{0}\n".format(psutil.disk_io_counters()))
    txt_file.write("--- System-wide Network I/O statistics---\n{0}\n".format(psutil.net_io_counters(pernic=True)))
    counter += 1
    txt_file.close()
    print timestamp
    # set period of time to run txt_to_file() function
    threading.Timer(int(period), txt_to_file).start()

def json_to_file():
    # write info to outputdata.json file
    timestamp = datetime.datetime.strftime(datetime.datetime.now(), '%Y-%m-%d %H:%M:%S')
    global counter

    json_file = open("outputdata.json", "a")
    json_file.write("\n\n###Snapshot {0} : {1} ###\n".format(counter, timestamp))
    json_file.write("\n --- System-wide CPU utilization per cpu---\n")
    json.dump(psutil.cpu_percent(interval=1, percpu=True), json_file, indent=4)
    json_file.write("\n --- System Memory usage---\n")
    json.dump(convertTodict(psutil.virtual_memory()), json_file, indent=4)
    json_file.write("\n--- System-wide Swap memory statistics---\n")
    json.dump(convertTodict(psutil.swap_memory()), json_file, indent=4)
    json_file.write("\n --- System-wide Disk I/O statistics---\n")
    json.dump(convertTodict(psutil.disk_io_counters()), json_file, indent=4)
    json_file.write("\n --- System-wide Network I/O statistics---\n")
    json.dump(psutil.net_io_counters(pernic=True), json_file, indent=4)
    counter += 1
    json_file.close()
    print timestamp
    # set period of time to run json_to_file() function
    threading.Timer(int(period), json_to_file).start()


if file_type == "txt":
    print('Output file type = ' + file_type + ', interval = ' + period + ' seconds')
    txt_to_file()
elif file_type == "json":
    print('Output filetype = ' + file_type + ', interval = ' + period + ' seconds')
    json_to_file()
else:
    print("Bad filetype in config file")
    quit()