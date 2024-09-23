import network
import usocket as socket
import time
import json

ssid="ravi"
passwd="April2023"

# Set up WiFi connection
sta_if = network.WLAN(network.STA_IF)
sta_if.active(True)
sta_if.connect(ssid, passwd)


# Wait for connection to be established
while not sta_if.isconnected():
    pass

print("Connected to WiFi")

# Server Connection Info
HOST = "192.168.159.72"
PORT = 3005

device_id="2222"

# Create connection

print("line 30!")



# Close the connection socket between the device and the server
# s.close()
msg = json.dumps({"message": "nikhil!", "deviceId":device_id,})


    

def send_data(msg):
    s = socket.socket()
    s.connect((HOST, PORT))
    
    s.send(msg.encode())
    print("data sent to mobile is",msg.encode())
    time.sleep(5)
    s.close()
    time.sleep(0.2)


send_data(msg)



