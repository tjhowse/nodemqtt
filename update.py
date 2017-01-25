import paho.mqtt.client as mqtt
import ssl
from time import sleep
import hashlib
import sys
import SimpleHTTPServer
import SocketServer

def on_connect(client, userdata, flags, rc):
	client.publish(sys.argv[1]+"/update",'{"host": "192.168.1.100","port": 8080,"src": "/'+sys.argv[2]+'","dst": "'+sys.argv[2]+'","hash":"'+hash+'"}',0,True)
	# client.publish(sys.argv[1]+"/delete",sys.argv[2],0,True)
	client.disconnect()

client = mqtt.Client()
client.on_connect = on_connect
client.tls_set('root_ca.pem',tls_version=ssl.PROTOCOL_TLSv1_1)
client.username_pw_set("me", password="myPW")

hash = hashlib.md5(open(sys.argv[2], 'rb').read()).hexdigest()

client.connect("bums.com", 8883, 60)
PORT = 8080
Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
httpd = SocketServer.TCPServer(("", PORT), Handler)
client.loop_forever()
httpd.serve_forever()