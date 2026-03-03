---
name: run
description: "Run rclone commands using the Docker container. Use when users need to sync, copy, list, or perform any file operations with rclone using the Docker image."
---

# Running Rclone Commands

Execute rclone commands inside the Docker container.

## Basic Usage

```bash
docker run --rm \
    -v /path/to/config:/config \
    -v /path/to/data:/data \
    rclone:latest \
    rclone <command> [flags]
```

## Common Commands

### List All Remotes

```bash
docker run --rm \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone listremotes
```

### List Files in a Remote

```bash
docker run --rm \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone ls remote:bucket
```

### Sync Files (Source → Remote)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone sync /data remote:bucket/prefix
```

### Copy Files (Source → Remote)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone copy /data remote:bucket/prefix
```

### Download Files (Remote → Local)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone copy remote:bucket/prefix /data
```

### Check Sync Differences

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone check /data remote:bucket/prefix
```

## Mount as Filesystem (Background)

```bash
docker run -d \
    --name rclone-mount \
    -v /path/to/data:/data \
    -v $(pwd)/config:/config \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --security-opt apparmor:unconfined \
    rclone:latest \
    rclone mount remote:bucket /data --vfs-cache-mode writes
```

Note: Mounting requires additional Docker privileges and is not recommended for most use cases.

## Volume Mounts

| Volume | Path in Container | Purpose |
|--------|-------------------|---------|
| `-v /path/to/config:/config` | `/config` | rclone.conf file |
| `-v /path/to/data:/data` | `/data` | Data to sync/copy |

## Common Flags

| Flag | Description |
|------|-------------|
| `-v` | Verbose output |
| `--dry-run` | Show what would happen without making changes |
| `--progress` | Show progress during transfer |
| `--stats` | Set statistics interval |
| `--transfers` | Number of concurrent transfers |
| `--bwlimit` | Bandwidth limit |

## Examples

### Dry Run Sync

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone sync /data remote:bucket --dry-run -v
```

### Sync with Progress

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone sync /data remote:bucket --progress --transfers 4
```

### Backup with Logging

```bash
docker run --rm \
    -v /volume1/backup:/data \
    -v $(pwd)/config:/config \
    rclone:latest \
    rclone sync /data remote:bucket/backup -v --log-file /tmp/rclone.log
```

## Reference

For complete documentation on all rclone commands and options, see: https://rclone.org/

## When to Use This Skill

Use this skill when:
- Syncing files to/from cloud storage
- Copying files between local and remote
- Listing or browsing remote files
- Backing up data to cloud storage
- Any file operation supported by rclone

## Tips

- Always use `--dry-run` first to verify what will happen
- Use `-v` flag for verbose output during testing
- Mount your config directory to `/config` for persistent remotes
- Use `--transfers 4` or higher for faster parallel transfers
