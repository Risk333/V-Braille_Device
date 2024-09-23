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

device_id="1111"

# Create connection

print("line 30!")

# A function we can call multiple times with different inputs
# def send_data(msg):
#     print("line 35!")
#     print(msg)
#     
#     
#     s.send(msg.encode())
#     response = s.recv(1024).decode()
#     return response
# 
# # Will print the server responses after each data request
# print(send_data('Hello,'))
# # print(send_data('Server!'))
# print("line 46!")


# Close the connection socket between the device and the server
# s.close()

msg = json.dumps({"deviceId":device_id,})


while True:
    s = socket.socket()
    s.connect((HOST, PORT))
    
    s.send(msg.encode())
    time.sleep(2)
    
    data_recieved=s.recv(1024).decode()
    print("data recieved from mobile is",data_recieved)
    s.close()
    time.sleep(0.2)

