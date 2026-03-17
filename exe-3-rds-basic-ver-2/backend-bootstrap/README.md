# Terraform Backend Bootstrap

Kho mã này tạo ra một bucket Amazon S3 bảo mật dùng để lưu trữ state Terraform từ các dự án khác. Mỗi dự án hoặc môi trường có thể có một backend riêng bằng cách chạy lại cấu hình với `bucket_prefix` khác (đoạn suffix ngẫu nhiên được thêm vào để bảo đảm tên bucket duy nhất). DynamoDB table cho state locking hiện chưa được bật theo yêu cầu.

## Yêu cầu

- Terraform 1.0 trở lên
- Tài khoản AWS có quyền tạo và cấu hình S3 bucket (xuất thông qua `AWS_PROFILE`, `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`, ...)

## Cách sử dụng

1. **Khởi tạo Terraform**

   ```sh
   terraform init
   ```

2. **Đặt tham số** (tùy chọn) bằng cách tạo file `*.tfvars`, ví dụ `backend-app1.auto.tfvars`:

   ```hcl
   bucket_prefix = "tf-state-app1"
   region        = "ap-southeast-1"
   tags = {
     Environment = "app1"
     ManagedBy   = "Terraform"
   }
   ```

3. **Tạo backend**

   ```sh
   terraform apply -auto-approve -var-file=backend-app1.auto.tfvars
   ```

   Terraform sẽ in ra `bucket_name`, `bucket_region`, `bucket_arn`. Ghi lại tên bucket để cấu hình backend cho dự án khác.

## Dùng bucket trong dự án Terraform khác

Chỉnh backend block của dự án cần state chung:

```hcl
terraform {
  backend "s3" {
    bucket = "tf-state-app1-<random>"
    key    = "project-a/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
  }
}
```

Sau đó chạy `terraform init -reconfigure` trong dự án đó để gắn vào bucket mới.

## Tạo thêm backend mới

Lặp lại phần **Cách sử dụng** với `bucket_prefix` khác (hoặc file `.tfvars` khác) cho mỗi backend mong muốn. Mỗi lần chạy sẽ tạo một bucket S3 độc lập.

## Dọn dẹp

Chỉ phá hủy backend khi chắc chắn không còn dự án nào dùng state trong bucket đó:

```sh
terraform destroy -auto-approve -var-file=backend-app1.auto.tfvars
```

Nếu muốn xóa cả các object còn lại trong bucket, sửa `force_destroy = true` trong `main.tf` (không khuyến khích trừ khi bắt buộc).
