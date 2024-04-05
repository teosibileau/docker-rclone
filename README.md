# Docker Rclone

Dockerized [rclone](https://rclone.org/) - a command line program to sync files and directories to and from various cloud services.

Spinoff of [tynor88/rclone](https://github.com/tynor88/docker-rclone).

## Usage

```
docker run -it \
           -v ~/Desktop/JRC:/data \
           -v ~/.config/rclone/:/config/ \
           rclone:latest \
           rclone --config /config/rclone.conf sync --interactive /data s5p8backup:s5p8-backup/JRC
```

**Parameters**

* `-v /config` The path where the .rclone.conf file is
* `-v /data` The path to the data which should be backed up by rclone
