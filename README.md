# Linstore-GUI-Docker

This docker is designed to easily deploy the linstor-gui npm package as per https://github.com/LINBIT/linstor-gui

I created this since the linstor-gui package has not yet been added to the proxmox public repos yet and I was not able to get the Ubuntu PPA to function in a standalone manner.

This docker just git clones that repo and setups up npm appropriately. It then configures the .env file according the docker environment variables on startup and runs the program. 

The gui in this docker is standalone and will reach out to your cluster assuming all variables are configured correctly.

I was not able to determine where any of the gui configuration settings were saved so for now the docker volume contains the entire git cloned repo inside of it. 

# Variables 
### CONTROLLER_HOST
This field is mandatory, configure the fqdn address for your linstor-controller. Assuming this is a highly available controller use it's VIP. The Default port is 3370

Example:
```yml
CONTROLLER_HOST=http://192.168.0.1:3370
```
### GATEWAY_HOST 
This field is optional, configure it only if using linstor-gateway. The default port is 8080

Please note that even if this option is configured you still need to enable the linstor gateway option in the settings of the linstor-gui for this to function.

Example:
```yml
GATEWAY_HOST=http://192.168.0.1:8080
```
### VSAN_HOST
This field is Optional, configure it if using vsan. The default appears to default to https over the standard 443.

Example:
```yml
VSAN_HOST=https://192.168.0.1
```

# Docker Compose Deployment Example
```yml
services:
  linstor-gui:
    image: ghcr.io/rumenblack84/linstor-gui-docker:latest
    environment:
      - user=1000:1000 #Match to the UID & GID of the user you want to run the docker as. It's important they have permission to access the files where we have our bind mount located. This will also avoid running the container process itself as root which is good for security.
      - UMASK=022 # set umask 022 will cause all files to have 755 perms\
      - CONTROLLER_HOST=http://192.168.0.1:3370  # mandatory, configure the IP address for your linstor-controller. Assuming this is a highly available controller use it's VIP. Default port is 3370
      - GATEWAY_HOST=http://192.168.0.1:8080  # Optional, configure only if using linstor-gateway. Default port is 8080
      - VSAN_HOST=https://192.168.0.1  # Optional, configure if using vsan. Default Port is 8080
    ports:
      - "12843:8080"
    volumes:
      - /appdata/linstor-gui:/config
    restart: unless-stopped      
```

# Known issues

* Please keep in mind since git clone is being used the operation will fail if the volume or bind mount used for /config is not completely empty (including any hidden files). This will of course cause the rest of the container to fail as we don't have the needed files. This is only really a consideration on the first run. Afterwards it skips the cloning if it detects a .git directory inside of /config
* Right now the only way to update is to either manually run a git pull on the volume or bind mount. I havn't tested this yet but I believe configs should be preserved. It should also be possible to just delete the contents of the bind mount in order to cause a fresh git clone. If I can find out where the configs are actually kept I will change the bind mount to only include that in the future.

# Requests
* if anyone has any ideas how the configuration files are kept for the linstor gui please let me know. Are they kept in a DB file inside the npm directory? Do they piggy back off the linstor controller db? I have no idea, but I'd like to find out to optimize this a little bit more.