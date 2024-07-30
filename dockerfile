# ใช้ Flutter image ที่เหมาะสม
FROM cirrusci/flutter:stable AS builder

# ตั้งค่าการทำงาน
WORKDIR /app

# คัดลอกไฟล์โค้ดไปยัง Docker image
COPY . .

# ดำเนินการคำสั่งเพื่อดึง dependency
RUN flutter pub get

# สร้าง build
RUN flutter build web

# สร้าง image ใหม่สำหรับ runtime
FROM nginx:alpine

# คัดลอก build output ไปยัง nginx
COPY --from=builder /app/build/web /usr/share/nginx/html

# เปิดพอร์ตที่ nginx ใช้
EXPOSE 80

# สั่งให้ nginx รัน
CMD ["nginx", "-g", "daemon off;"]







