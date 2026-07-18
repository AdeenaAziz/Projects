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

## Automating with cron

To run the report automatically every day at 6 PM:

1. Open your crontab:
```bash
   crontab -e
```
2. Add this line (update the paths to match where you cloned the repo):
0 18 * * * /home/ubuntu/Projects/shell/aws-resource-tracker/adeena.sh >> /home/ubuntu/tracker.log 2>&1


3. Save and exit. Verify it was added:
```bash
   crontab -l
```

From then on, the script runs unattended every day at the scheduled time, appending output (and any errors) to `tracker.log`.

## How it works (brief)

The script runs four AWS CLI calls in sequence:
```bash
aws s3 ls
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'
aws lambda list-functions
aws iam list-users
```
The EC2 call is piped through `jq` to pull out just the `InstanceId` field from the nested JSON response, instead of dumping the full (much larger) instance description.

## Limitations / next steps

- This is a learning-project scope (4 services, single AWS account/region, no error retries).
- In production, this kind of tracking is usually pushed to a monitoring/dashboard tool (e.g., CloudWatch, a cost dashboard, Slack/email alerts) rather than a flat text file.
- Possible extensions: multi-region support, cost estimates via Cost Explorer API, S3 bucket sizes, unattached EBS volume detection, Slack/email delivery of the report.

## License

MIT

## Author

Adeena Aziz
EOF
