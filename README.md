# klipper-s3bck
Backup Klipper to S3 Storage like Minio.

This README needs to be completed...


# Minio Install and Config

Install Minio on a System inside your local Network. 
I use a Raspberry PI5 with a 1TB NVMe drive.
I use *minio* as the hostname and *pi* as the username in the examples.

* **Step 1:** Download an install Minio
```shell
wget https://dl.min.io/server/minio/release/linux-arm64/archive/minio_20241218131544.0.0_arm64.deb -O minio.deb
sudo dpkg -i minio.deb
```

* **Step 2:** Create minio config file.

Minio configuration used by systemd is stored in /etc/default/minio

Here is a sample config.
```
pi@minio:~ $ cat /etc/default/minio 
# MINIO_ROOT_USER and MINIO_ROOT_PASSWORD sets the root account for the MinIO server.
# This user has unrestricted permissions to perform S3 and administrative API operations on any resource in the deployment.
# Omit to use the default values 'minioadmin:minioadmin'.
# MinIO recommends setting non-default values as a best practice, regardless of environment

MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD='Ganz-sicheres-Password'

# MINIO_VOLUMES sets the storage volume or path to use for the MinIO server.

MINIO_VOLUMES="/minio-data"

# MINIO_OPTS sets any additional commandline options to pass to the MinIO server.
# For example, `--console-address :9001` sets the MinIO Console listen port
MINIO_OPTS="--console-address :9001"
```  
<br>
  
* **Step 3:** Change systemd config for minio

You need to change User and Group to you own needs.

```
sudo systemctl edit --full minio.service
```

* **Step 4:** Create data directory.

We need to create the data directory (MINIO_VOLUMES from config file) now.  
Place it whereever you want.

```shell
sudo mkdir /minio-data
sudo chown
sudo chmod 700 /etc/default/minio
```

* **Step 5:** Start Minio Service

We are ready to start the service.

```shell
systemctl enable --now minio.service
sudo systemctl status minio.service
```

The status output should look like this...

<code>
minio.service - MinIO\
     Loaded: loaded (/etc/systemd/system/minio.service; enabled; preset: enabled)\
     Active: active (running) since Fri 2025-01-17 15:46:51 CET; 1h 0min ago\
       Docs: https://docs.min.io\
   Main PID: 702 (minio)\
      Tasks: 10\
        CPU: 4.275s\
     CGroup: /system.slice/minio.service\
             └─702 /usr/local/bin/minio server --console-address :9001 /minio-data\
Jan 17 15:46:50 minio systemd[1]: Starting minio.service - MinIO...\
Jan 17 15:46:51 minio systemd[1]: Started minio.service - MinIO.\
Jan 17 15:46:51 minio minio[702]: MinIO Object Storage Server\
Jan 17 15:46:51 minio minio[702]: Copyright: 2015-2025 MinIO, Inc.\
Jan 17 15:46:51 minio minio[702]: License: GNU AGPLv3 - https://www.gnu.org/licenses/agpl-3.0.html\
Jan 17 15:46:51 minio minio[702]: Version: RELEASE.2024-12-18T13-15-44Z (go1.23.4 linux/arm64)\
Jan 17 15:46:51 minio minio[702]: API: http://10.2.1.213:9000  http://127.0.0.1:9000\
Jan 17 15:46:51 minio minio[702]: WebUI: http://10.2.1.213:9001 http://127.0.0.1:9001\
Jan 17 15:46:51 minio minio[702]: Docs: https://docs.min.io
</code>

# Minio Web Interface 

Its time to check the WEB Interface. Point your Browser to WebUI URL listed in the output from shown above.
e.g. http://10.2.1.213:9001

You can login with the credentials from /etc/default/minio 

#################3
#
# mc CLI
#

$ curl https://dl.min.io/client/mc/release/linux-arm64/mc -o mc
$ chmod +x mc
$ ./mc
$ sudo mv mc /usr/local/bin/

$ mc alias set local http://localhost:9000 hergen 'Ganz-sicheres-Password'
Added `local` successfully.

$ mc alias set minio http://localhost:9000 hergen 'Ganz-sicheres-Password'
Added `minio` successfully.

####################
#
# User in Minio anlegen ueber GUI
# 
User: backup Password: backup123

#
# Bucket anlegen:
# 

$ mc mb --with-lock backup/klipperbackups
Bucket created successfully `backup/klipperbackups`.

