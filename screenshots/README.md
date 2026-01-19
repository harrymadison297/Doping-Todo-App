# Screenshots Guide

Để hoàn thiện README, vui lòng thêm các screenshots sau vào folder này:

## Required Screenshots:

1. **app_icon.png** (512x512)
   - Icon của app với thiết kế clock + checkmark + tomato

2. **todo_list.png** 
   - Màn hình danh sách todo với statistics cards
   - Hiển thị một vài tasks ở trạng thái khác nhau

3. **add_task.png**
   - Màn hình thêm/sửa task
   - Form với title, description, deadline picker, repeat interval

4. **pomodoro_timer.png**
   - Màn hình Pomodoro với timer circle
   - Hiển thị đang trong work phase hoặc break phase

5. **settings.png**
   - Màn hình settings với language selection
   - Hiển thị English/Vietnamese options

6. **widgets.png**
   - Home screen Android với 2 widgets (Todo + Pomodoro)

7. **notification.png**
   - Notification với quick action button "Hoàn thành"

## Cách chụp screenshots:

### Trên Android:
```bash
# Chạy app
flutter run

# Chụp screenshot bằng:
- Power + Volume Down
- hoặc: adb shell screencap -p /sdcard/screenshot.png
```

### Trên macOS:
```bash
# Chạy app
flutter run -d macos

# Chụp screenshot bằng:
- Command + Shift + 4
```

### Widget Screenshots:
1. Thêm widget vào home screen
2. Chụp ảnh home screen

Sau khi có đủ screenshots, thay đổi các đường dẫn trong README.md từ placeholder sang tên file thực.
