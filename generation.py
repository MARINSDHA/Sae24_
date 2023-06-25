
import paho.mqtt.client as mqtt
import json
import time

# MQTT settings
broker_address = "localhost"
broker_port = 1883
topic = "mesures"

# List of binary words
mots_binaires = [
"0100000000", "1000000111", "1100000100",
"0100000000", "1000000101", "1100000100",
"0100000000", "1000000011", "1100000011",
"0100000000", "1000000101", "1100000010",
"0100000000", "1000000111", "1100000001",
"0100000000", "1000000111", "1100000000",
"0100000001", "1000000001", "1100000000",
"0100000001", "1000000011", "1100000000",
"0100000001", "1000000011", "1100000001",
"0100000001", "1000000101", "1100000010",
"0100000001", "1000000111", "1100000001",
"0100000010", "1000000001", "1100000000",
"0100000010", "1000000000", "1100000111",
"0100000010", "1000000000", "1100000110",
"0100000010", "1000000010", "1100000110",
"0100000010", "1000000100", "1100000110",
"0100000010", "1000000110", "1100000111",
"0100000010", "1000000101", "1100000000",
"0100000010", "1000000011", "1100000001",
"0100000010", "1000000001", "1100000010",
"0100000010", "1000000001", "1100000011",
"0100000010", "1000000011", "1100000011",
"0100000010", "1000000101", "1100000100",
  

]


# Function to publish binary words
def publier_mots_binaires(cap1, cap2, cap3):
    data = {
        "cap1": cap1,
        "cap2": cap2,
        "cap3": cap3
    }
    client.publish(topic, json.dumps(data, indent=2))

# Configuring the MQTT client
client = mqtt.Client()

# Connexion to broker MQTT
client.connect("192.168.159.129", 1883)

# Loop to post binary words in groups of three
index = 0
while index < len(mots_binaires):
    cap1 = mots_binaires[index]
    cap2 = mots_binaires[index+1]
    cap3 = mots_binaires[index+2]

    # Display of binary words
    print(f"cap1={cap1}\n")
    print(f"cap2={cap2}\n")
    print(f"cap3={cap3}\n")

    # Publication of binary words
    publier_mots_binaires(cap1, cap2, cap3)

    # 20 second break
    time.sleep(20)

    # Increment index for binary words
    index += 3

# Déconnexion to broker MQTT
client.disconnect()
