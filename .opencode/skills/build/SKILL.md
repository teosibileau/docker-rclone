---
name: build
description: "Build the Docker image and generate an rclone config file. Use when users need to set up the rclone Docker image locally or generate a configuration file for cloud storage providers."
---

# Build and Configure Rclone Docker Image

Build the Docker image locally and generate an rclone configuration file.

## Prerequisites

- Docker installed and running
- This project cloned locally

## Commands

### Build the Docker Image

```bash
make build
```

Or using Docker directly:

```bash
docker build -t rclone:latest .
```

**Output:**
```
Sending build context to Docker daemon  5.12MB
Step 1/XX : FROM alpine:latest
...
Successfully built xxx
Successfully tagged rclone:latest
```

### Generate Rclone Config

Create an rclone configuration file interactively:

```bash
make config
```

Or using Docker directly:

```bash
docker run --rm -it \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone config
```

This command:
1. Creates `./config` directory if it doesn't exist
2. Runs rclone's interactive configuration wizard
3. Saves the config to `./config/rclone.conf`

## Configuration Process

The `rclone config` command will prompt you to:

1. **n) New remote** - Create a new cloud storage connection
2. **s) Set configuration password** - Optional, for encrypting config
3. **q) Quit config** - Exit when done

### Adding a Cloud Provider

Example for S3-compatible storage:

```
n) New remote
name> my-s3
Storage> s3
provider> AWS
access_key_id> AKIAIOSFODNN7EXAMPLE
secret_access_key> wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region> us-east-1
endpoint>
location_constraint>
acl>
Edit advanced config? (y/n) y/n> n
Remote config...
--------------------
[y/n] y
--------------------
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y
```

## Output

- **Docker image:** `rclone:latest` (local only)
- **Config file:** `./config/rclone.conf`

## Next Steps

After creating the config, you can:

1. Copy the config to your NAS/server:
   ```bash
   scp config/rclone.conf user@nas:/path/to/rclone/
   ```

2. Run sync commands:
   ```bash
   docker run --rm \
       -v /path/to/data:/data \
       -v /path/to/rclone:/config \
       rclone:latest \
       rclone sync /data remote:bucket
   ```

## When to Use This Skill

Use this skill when:
- Setting up rclone Docker image for the first time
- Configuring new cloud storage remotes
- Updating existing rclone configuration
- Rebuilding the Docker image after Dockerfile changes
