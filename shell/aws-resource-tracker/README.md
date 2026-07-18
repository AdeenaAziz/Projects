cd ~/Projects/shell/aws-resource-tracker
cat > README.md << 'EOF'
# AWS Resource Usage Tracker (Shell Script)

A lightweight Bash script that reports on AWS resource usage — **S3, EC2, Lambda, and IAM users** — and can be scheduled to run automatically via `cron`. Built as a DevOps learning project to demonstrate combining **Bash scripting** with the **AWS CLI** and **`jq`** for real-world cost/resource tracking.

## Why this exists

Cloud cost control is one of the core responsibilities of a DevOps/cloud engineer. Resources like idle EC2 instances or unattached EBS volumes are easy to forget about but still get billed. This script gives a quick daily snapshot of what's provisioned across a few common services, so usage doesn't silently drift and rack up cost.

## Features

- Lists all S3 buckets
- Lists EC2 instances (parsed down to just instance IDs via `jq`)
- Lists Lambda functions
- Lists IAM users
- Human-readable, labeled output (no more guessing which block of output belongs to which service)
- Can be redirected to a report file and scheduled with `cron` for daily automated reporting
- Includes a debug/trace mode (`set -x`) for troubleshooting

## Prerequisites

- **Bash** (script uses `#!/bin/bash`, not `/bin/sh`)
- **AWS CLI v2**, installed and configured with credentials that have read access to S3, EC2, Lambda, and IAM
```bash
  aws configure
```
- **`jq`** (JSON processor), used to parse the EC2 `describe-instances` output
```bash
  sudo apt install jq       # Debian/Ubuntu
  sudo yum install jq       # RHEL/CentOS/Amazon Linux
```

## Installation

```bash
git clone https://github.com/AdeenaAziz/Projects.git
cd Projects/shell/aws-resource-tracker
chmod +x adeena.sh
```

> Avoid `chmod 777` in real use — `chmod +x` (or `chmod 750`) is enough and keeps the script from being world-writable.

## Usage

Run it directly:
```bash
./adeena.sh
```

Save the output to a report file instead of printing to the terminal:
```bash
./adeena.sh > resource_tracker.txt
```

Enable debug/trace mode to see each command as it runs (useful for troubleshooting):
```bash
set -x
./adeena.sh
set +x
```

## Example output
