#!/bin/bash
yum update -y
yum install -y httpd amazon-cloudwatch-agent mod_ssl
systemctl enable httpd
systemctl start httpd
cat > /var/www/html/index.html <<'EOF'
<!doctype html>
<html>
  <head><title>${app_name} Web App</title></head>
  <body><h1>Welcome to Paymentology</h1><p>Terraform-managed web tier in ${environment} environment</p></body>
</html>
EOF
cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json <<'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "namespace": "CWAgent",
    "append_dimensions": {
      "InstanceId": "$${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["used_percent"],
        "resources": ["/"],
        "metrics_collection_interval": 60
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "/aws/asg/${app_name}-web",
            "log_stream_name": "{instance_id}/httpd/access",
            "retention_in_days": 30
          },
          {
            "file_path": "/var/log/httpd/error_log",
            "log_group_name": "/aws/asg/${app_name}-web",
            "log_stream_name": "{instance_id}/httpd/error",
            "retention_in_days": 30
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/aws/asg/${app_name}-web",
            "log_stream_name": "{instance_id}/system",
            "retention_in_days": 30
          },
          {
            "file_path": "/var/log/cloud-init-output.log",
            "log_group_name": "/aws/asg/${app_name}-web",
            "log_stream_name": "{instance_id}/cloud-init",
            "retention_in_days": 30
          }
        ]
      }
    }
  }
}
EOF
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
