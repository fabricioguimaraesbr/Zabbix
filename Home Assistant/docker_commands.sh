docker run --init -d --restart=unless-stopped --name="home-assistant" -e "TZ=America/Sao_Paulo" -v /Users/fabricioguimaraes/Documents/HA_Config:/config -p 8123:8123 homeassistant/home-assistant:latest
docker run --init -d --restart=unless-stopped --name="node-red" -e "TZ=America?Sao_Paulo" -v /Users/fabricioguimaraes/Documents/NR_Config:/data -p 1880:1880 nodered/node-red
