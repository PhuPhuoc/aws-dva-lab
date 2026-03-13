## Danh Sách các Modules & Resource Phổ Biến trong Terraform Production
File này liệt kê các modules thường dùng, tài nguyên (AWS service/resource) chủ yếu của từng module và tư duy tổ chức code thực tế. Mỗi module có thể bổ sung/sub-modules hoặc chia nhỏ phù hợp cho hệ thống thực tế.

---

| Module Name    | Service/Resource Chính                                                       | Ví dụ & Tư duy tổ chức file/module                                                           |
|----------------|------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| **network/**       | VPC, Subnet (public/private), IGW, NAT GW, Route Table, Peering              | Dùng cho mọi hệ thống, đảm bảo tách biệt public/private. outputs.tf xuất vpc_id, subnet_ids. |
| **security_group/**| AWS Security Group, có thể thêm NACL                                         | Tối ưu hóa rule, chia nhỏ group theo app, tier. outputs.tf xuất sg_id và mapping cần dùng.   |
| **compute/**       | EC2, Launch Template, Auto Scaling Group                                     | Nên viết linh hoạt số lượng, loại instance, tag. Trong ASG, tạo lifecycle policy riêng.      |
| **alb/**           | ALB, Target Group, Listener, Listener Rule                                   | Linh động port, rules, attach instances hoặc autoscaling.                                    |
| **database/**      | RDS Instance/Cluster, Subnet/Parameter Group, Option Group                   | outputs.tf nên export endpoint, username, password cần thiết (dùng data nguồn secret mgmt).  |
| **ecr/**           | ECR Repository, policy, lifecycle policy                                     | Có thể tạo/destroy lifecycle, add cross-account, scan image, v.v.                            |
| **ecs/**           | ECS Cluster, Service, Task Def, IAM, Capacity Provider                       | Ràng buộc role, environment, chia service CRUD thành submodule; outputs.tf export ARN.       |
| **s3/**            | S3 Buckets, policy, version, lifecycle, replication                          | Đặt thêm module logs/backup riêng nếu scale lớn.                                             |
| **iam/**           | Role, Policy, Attach, Instance Profile, Trust Relationship                   | Đặt convention tên theo team/project, clean up policy “*”. Gắn tag và mô tả kỹ lưỡng.        |
| **cloudfront/**    | Distribution, Origin, Behaviors, Cache/Origin Policy                         | Module này thường attach outputs từ S3/ALB.                                                  |
| **lambda/**        | Function, Alias, Permission, Trigger, Layer, Event Source                    | Có thể tách trigger SQS/SNS/S3/CloudWatch làm submodule nhỏ.                                 |
| **route53/**       | Zone, Record, Health Check, Failover Policy, Resolver                        | outputs.tf xuất all record alias/app endpoint. Thường ref domain từ app module khác.         |
| **bastion/**       | Bastion EC2 Instance, SG, SSM Policy                                         | Dùng cho secure jump vào private subnet hoặc chỉ SSM; Gán role riêng chỉ cho IAM nhóm quản trị.|
| **autoscaling/**   | ASG, Scaling Policy, Notification                                            | outputs.tf export launch_template_id, scaling_arn, metric_alarm cho scale-out/vào            |
| **elasticache/**   | Redis/Memcached, Subnet Group, SG, Parameter Group                           | outputs.tf nên xuất endpoint + cluster_id, gắn tag rõ cache-for-app nào.                     |
| **msk/**           | MSK Cluster, Configuration, client IAM                                       | Tắt public nếu không cần; outputs.tf xuất endpoint, VPC sg, IAM arn connect.                 |
| **sns/**           | Topic, Subscription, Policy                                                  | Nối trực tiếp Lambda/SQS/SMS quan trọng, export topic_arn.                                   |
| **sqs/**           | Queue, Deadletter, Policy, Redrive Policy                                    | Output các queue_url & arn, gán tag app/service logic clear.                                 |
| **ssm/**           | Parameter Store, Secrets Manager, Document, Session Manager                  | Tích hợp sẵn policy IAM, outputs.tf xuất arn, name, version cho các service/app khác kết nối |
| **backup/**        | AWS Backup Plan, Vault, Selection, Framework                                 | Nên có naming convension, outputs.tf export arn/vault_name.                                  |
| **cloudwatch/**    | Log Group, Metric Alarm, Dashboard, Log Subscription                         | outputs.tf xuất log_group, alarms_id hoặc dashboard url cho giám sát.                        |
| **logs/**          | Central Log Group, Firehose, filter                                          | Có thể xuất thêm raw/analytics bucket cho team data.                                         |
| **monitoring/**    | Alert, notify, tích hợp monitoring ngoài (Datadog, PagerDuty, Slack, ... )   | Tách các channels/endpoint ra riêng cho dễ audit và maintain                                 |
| **acm/**           | Certificate, Validation record                                               | output cert_arn, validation status, attach với ALB/CloudFront/S3 host static                 |

---
### Ghi chú triển khai:
- Mỗi module nên có: `main.tf`, `variables.tf`, `outputs.tf`, bổ sung README.md nếu module lớn/phức tạp.
- Trong outputs.tf nên export các ID, endpoint, ARN cần thiết/phổ biến để tái sử dụng giữa các module.
- Module lớn cho phép submodules (ví dụ `database/mysql/`, `ecs/fargate/`)
- Nên tách riêng module “security” liên quan đến KMS, secrets, logs nếu dùng nhiều service nhạy cảm.
- Code trong mỗi module nên make use of input variables, avoid hardcoding, chuẩn convention đặt tên/logical id/tag.

**Vị trí file này:**
/home/phuoctran/workspace/active/aws-dva-lab/exe-2-update-structure/NOTE.md
