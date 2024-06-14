#!/bin/bash

# Get the MAC address of eth0
MAC_ADDRESS=$(cat /sys/class/net/eth0/address)
echo "MAC Address: $MAC_ADDRESS"

# Read the SSH public key from the specified file
ssh_key=$(cat ~/.ssh/mykey.pub)
echo "SSH Key: $ssh_key"

# Define the local ports and corresponding Docker addresses
PORT_HOME_ASSISTANT=("8123" "HOME_ASSISTANT")
PORT_MAC_ADRESSE=("8080" "MAC_ADRESSE")

# Define the data column for mapping purposes
datacol=("PORT_HOME_ASSISTANT" "PORT_MAC_ADRESSE")

# Make a GET request to the API to register and capture the response
response=$(curl -X GET 'https://api.proxy.ski-sync.com/api/register' \
    --header 'Content-Type: application/json' \
    --data-raw "{
    \"address_mac\": \"$MAC_ADDRESS\",
    \"ssh_key\": \"$ssh_key\",
    \"ports\": [
        {
            \"port\": 8123,
            \"protocol\": \"Http\"
        },
        {
            \"port\": 8080,
            \"protocol\": \"Http\"
        }
    ]
}")

echo "API Response: $response"

# Assuming the response is a JSON array of port numbers, e.g., [1234, 5678]
# Clean up the response to extract the port numbers
cleaned_ports=$(echo $response | tr -d '[]')
IFS=',' read -r -a port_array <<< "$cleaned_ports"

echo "Cleaned Ports: ${port_array[@]}"

# Check if we received the expected number of ports
if [ "${#port_array[@]}" -ne "${#datacol[@]}" ]; then
  echo "Error: The number of ports in the response does not match the expected number."
  exit 1
fi

# Loop through the datacol array and set up SSH tunnels
for i in "${!datacol[@]}"; do
  # Map the data column to local port descriptions
  declare -n array="${datacol[$i]}"

  # Extract the remote port from the response, considering the correct index
  remote_port=${port_array[$i]}

  # Extract local port and Docker address from the corresponding array
  local_port=${array[0]}
  docker_address=${array[1]}

  echo "Setting up tunnel: Remote Port: $remote_port, Local Port: $local_port, Docker Address: $docker_address"

  # Set up the autossh command
  autossh -M 0 -f -N -v -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" \
    -o "IdentityFile=~/.ssh/mykey" \
    -R $remote_port:$docker_address:$local_port root@ec2-16-170-224-5.eu-north-1.compute.amazonaws.com -p 2222
done
