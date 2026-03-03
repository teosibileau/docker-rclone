# Docker Rclone

Dockerized [rclone](https://rclone.org/) - a command line program to sync files and directories to and from various cloud services.

Spinoff of [tynor88/rclone](https://github.com/tynor88/docker-rclone). I needed a less asuming version to access the plain rclone command directly.

## Usage

```
docker run -it \
           -v <host_data>:/data \
           -v <host_config>:/config/ \
           rclone:latest \
           rclone --config /config/rclone.conf sync \
           /data \
           <target>
```

### Synology usecase

I use the following to sync my NVR videos to an s3 bucket (Synology Cloud sync sucks). I have a task scheduled every 5 minutes running:

```
docker run --rm \
            -v /volume1/agentdvr:/data \
            -v /var/services/homes/admin/rclone/:/config/
            <rclone_image> \
            rclone -v --config /config/rclone.conf sync --size-only --fast-list /data <s3_remote>:<s3_bucket>/agentdvr
```

It's easier to generate a working rclone config locally and copying that folder to the NAS. You can do that by:

```
# Build the Docker image locally
make build

# Generate an rclone config file interactively
# Creates ./config/rclone.conf
make config
```

The `make config` command runs rclone's interactive configuration and saves the result to `./config/rclone.conf`, which you can then copy to your NAS.

**Parameters**

* `-v /config` The path where the .rclone.conf file is
* `-v /data` The path to the data which should be backed up by rclone
