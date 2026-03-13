# Tổng quan Flow CI/CD cho Terraform

## 1. Lợi ích triển khai CI/CD với Terraform
- Tự động kiểm tra, phát hiện lỗi cú pháp, validate trước khi apply lên hạ tầng.
- Hạn chế lỗi thao tác thủ công, giúp kiểm soát version state và history thay đổi IAC chặt chẽ.
- Đảm bảo best practice: code review, approval workflow (terraform plan -> review -> apply).
- Kết hợp kiểm thử, policy (Opa/Checkov/TFLint...) tạo pipeline an toàn.

## 2. Sơ đồ tổng quan CI/CD

1. **Developer push/pull request** lên repo
2. **CI Pipeline** tự động chạy:
   - Lint/check format (terraform fmt, terraform validate)
   - Init backend (terraform init)
   - Run plan (terraform plan), chụp output artifact/log
   - Lưu/đánh dấu kết quả plan (comment vào MR/PR...)
3. **Manual Approval** (code reviewer/DevOps leader kiểm tra diff)
4. **CD Pipeline** (chỉ chạy trên nhánh chính hoặc khi đã approve):
   - Run apply (terraform apply -auto-approve), ghi log audit
   - Lưu lại state và outputs
5. **Notify** (Slack/Email/MS Teams...)

![Terraform CI/CD Flow](https://user-images.githubusercontent.com/7629088/146449082-3e2bb7e2-d2fb-4b2e-acde-bfd44a4035e1.png)

---
## 3. Ví dụ pipeline cơ bản (GitHub Actions)

```yaml
yaml
name: 'Terraform CI/CD'
on:
  pull_request:
    paths: ['envs/dev/**', 'modules/**', 'main.tf', 'variables.tf', 'outputs.tf']
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: envs/dev
    steps:
      - uses: actions/checkout@v2
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.6.2
      - name: Terraform Format
        run: terraform fmt -check
      - name: Terraform Init
        run: terraform init -input=false
      - name: Terraform Validate
        run: terraform validate
      - name: Terraform Plan
        run: terraform plan -out=tfplan -input=false
      # (Optional) upload plan log, comment diff to PR, v.v.
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve tfplan
```

## 4. Các lưu ý & Best Practices
- **Không nên tự động apply trên PR**. Chỉ apply khi branch chính đã merge/approve.
- **Sử dụng backend remote (S3+DynamoDB, GCS, Azure Storage...)** để tránh mất state.
- Bảo vệ secrets (AWS credentials, Terraform Cloud token,...) qua secret manager GitHub/GitLab.
- Áp dụng policy (OPA, Sentinel, Checkov, TFLint) vào pipeline.
- Có thể mở rộng thêm bước destroy, clean up, auto review cost estimate v.v.

## 5. Tài liệu tham khảo
- [Terraform Documentation - CI/CD Pipeline](https://developer.hashicorp.com/terraform/tutorials/aws/aws-codepipeline)
- [GitHub Actions for Terraform](https://github.com/marketplace/actions/hashicorp-setup-terraform)
- [Checkov - Modern policy as code](https://www.checkov.io/)

---
*CI/CD giúp team phát triển hạ tầng an toàn, kiểm soát chặt, rollback dễ dàng, đơn giản hóa quy trình build system quy mô lớn.*
