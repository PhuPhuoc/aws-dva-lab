# Terraform AWS Modular Repo Structure

## 1. Giới thiệu & Triết lý tổ chức repo

Repo này được thiết kế theo chuẩn tổ chức mô-đun (modular), tách biệt tài nguyên, hỗ trợ nhiều môi trường (multi-env) phù hợp cho teamwork & mở rộng thực tế. Cách setup này tuân thủ best-practices giúp:
- Dễ tái sử dụng cho các project khác nhau nhờ module hóa rõ ràng
- Tách biệt resource theo chức năng (network, compute, alb, v.v.), quản lý permission và quy mô dễ dàng
- Quản lý cấu hình từng môi trường (dev, prod, staging...) độc lập và an toàn hơn
- Dễ tích hợp CI/CD, audit, kiểm tra, rollout hoặc rollback nhanh

## 2. Sơ đồ cấu trúc & Ý nghĩa từng thành phần

```
<repo-root>/
├── modules/           # Thư mục chứa các module dùng lại, mỗi module tách 1 chức năng AWS
│   ├── network/         # Module cho VPC, subnet, route, NAT...
│   ├── compute/         # EC2, ASG, Launch Template...
│   ├── alb/             # Application Load Balancer
│   └── security_group/  # AWS Security Groups, NACL...
├── envs/              # Mỗi môi trường (dev, prod,...) thư mục riêng biệt
│   ├── dev/
│   └── prod/
├── scripts/           # Chứa các script khởi tạo EC2, user-data, tiện ích
├── README.md          # File hướng dẫn chính (bạn đang đọc)
├── NOTE.md            # Tài liệu notes, best-practices, gợi ý setup modules thực tế
```

### Ý nghĩa từng thành phần:
- `modules/`: Nơi định nghĩa các component công nghệ từng phần; mỗi module nên có `main.tf`, `variables.tf`, `outputs.tf`. Có thể chia nhỏ module để tái sử dụng ở nhiều môi trường.
- `envs/`: Quản lý file cấu hình từng environment tách biệt (backend, variables riêng). Giảm thiểu xung đột, tăng tính bảo mật và kiểm soát.
- `scripts/`: Tổng hợp file shell, script provisioning (user-data, bootstrap cho EC2, init app,...) dùng chung cho nhiều instance hoặc automation.
- `README.md`: Tài liệu hướng dẫn cấu trúc, cách sử dụng, giải thích ý nghĩa.
- `NOTE.md`: Danh sách modules phổ biến, best-practices, kinh nghiệm thực triển khai real-world. Đây là tài liệu hỗ trợ team khi muốn mở rộng/thay đổi module.

## 3. Tư duy tổ chức & điểm mạnh kiến trúc này

- **Separation of Concerns:** Module hóa từng nhóm resource giúp code clean, debug thuận tiện, refactor không ảnh hưởng lẫn nhau.
- **Multi-Environment Support:** Dễ dùng cùng lúc dev/staging/prod (không cần sửa code chính)
- **Reusability & Scalability:** Thêm môi trường, thêm module mới cực nhanh. Mỗi module có thể import tái sử dụng cho dự án/nhánh khác.
- **DRY Principle:** Các biến đầu vào (input variables), outputs rõ ràng. Không lặp code/mẫu, các giá trị đặc thù môi trường đưa vào envs/.
- **Best Practices Friendly:** Dễ tích hợp rule kiểm soát policy, naming convention, role IAM rõ ràng, chuẩn hóa workflow.
- **Team Collaboration:** Team dễ onboard, đọc hiểu, đóng góp, code review, kiểm thử. PR checklist nhanh.

## 4. Hướng dẫn sử dụng cơ bản

### Deploy một environment
1. Vào thư mục môi trường cụ thể (`envs/dev/` hoặc `envs/prod/`)
2. Thực thi tuần tự các lệnh:
   ```sh
   terraform init
   terraform plan
   terraform apply
   # (Check outputs như alb_dns, endpoint,...)
   ```

### Lưu ý
- **File `backend.tf` trong mỗi thư mục môi trường (envs/dev, envs/prod)**:
  - Đây là nơi khai báo backend cho Terraform state – giúp lưu trữ, quản lý trạng thái hạ tầng an toàn trên cloud (ví dụ S3+DynamoDB trên AWS).
  - Tại sao phải có?  
    + Đảm bảo tách biệt state của từng môi trường, tránh apply nhầm lẫn resource giữa dev/prod/staging.  
    + Cho phép teamwork hiệu quả: mọi thành viên cùng truy cập/chỉnh sửa state an toàn, có khóa lock, chống xung đột.
    + An toàn, backup lịch sử, tích hợp CI/CD, thuận tiện rollback nếu cần.  
    + Phù hợp best practices: không lưu state local (tránh mất mát, overwrite, lộ secrets), audit tốt hơn.
  - Nếu không có backend.tf (lưu state local): Rất dễ xảy ra lỗi mất file, thao tác nhầm môi trường, không phù hợp teamwork và CI/CD.
- User AWS phải có đủ quyền tạo tài nguyên liên quan (VPC, SG, EC2, ALB, S3, IAM, v.v.)
- Output mỗi module (outputs.tf) cần trả ra các ID, arn, endpoint quan trọng để chaining/config với modules khác.
- Khi thêm module mới cho 1 môi trường chỉ cần khai báo trong envs/<env>/main.tf và truyền biến phù hợp.
- Có thể mở rộng mô-đun lớn thành submodule (ví dụ modules/database/mysql/).

## 5. Kinh nghiệm & Best Practices (trích NOTE.md)
- Nên tách từng resource group thành module riêng để dễ maintain, tag tài nguyên logic-hoá.
- Module thiết kế input linh hoạt, output cần dùng cho các đoạn pipeline hoặc module khác.
- Triển khai thực tế: luôn có main.tf, variables.tf, outputs.tf cho mỗi module.
- Đặt tên rõ ràng, gắn tag cloud resource chuẩn hóa, đầy đủ mô tả; không hardcode giá trị nhạy cảm, ưu tiên lấy parameter store/secrets manager khi triển khai real-world.
- Có thể bổ sung README.md riêng cho mỗi module lớn/phức tạp.

## 6. Tài liệu tham khảo
- [Terraform Best Practices](https://www.terraform.io/docs/language/modules/develop/index.html)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- NOTE.md nội bộ repo này: Mô tả module phổ biến, lưu ý thực tiễn.

---
*Hãy duy trì tinh thần modular, tách biệt và rõ ràng – bạn sẽ tiết kiệm rất nhiều thời gian, chi phí, công sức vận hành phát triển hạ tầng AWS!*
