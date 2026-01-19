#!/bin/bash

# Script để chụp screenshots cho app Doping
# Run this script while app is running: ./capture_screenshots.sh

echo "📸 Doping Screenshots Capture Script"
echo "======================================"
echo ""

# Kiểm tra flutter devices
echo "🔍 Checking connected devices..."
flutter devices

echo ""
echo "📱 Instructions:"
echo "1. Make sure the app is running on your device"
echo "2. Navigate to the screen you want to capture"
echo "3. Use the following methods to capture:"
echo ""
echo "   Android:"
echo "   - Press Power + Volume Down"
echo "   - Or use: adb shell screencap -p /sdcard/screenshot.png"
echo "   - Then: adb pull /sdcard/screenshot.png screenshots/"
echo ""
echo "   iOS Simulator:"
echo "   - Press Cmd + S"
echo "   - Or use: xcrun simctl io booted screenshot screenshots/screenshot.png"
echo ""
echo "   macOS:"
echo "   - Press Cmd + Shift + 4, then Space, then click window"
echo ""

# Tạo folder nếu chưa có
mkdir -p screenshots

echo "✅ Screenshots folder ready at: screenshots/"
echo ""
echo "📋 Checklist of required screenshots:"
echo "  [ ] todo_list.png - Todo list with statistics"
echo "  [ ] add_task.png - Add/Edit task form"
echo "  [ ] pomodoro_timer.png - Pomodoro timer running"
echo "  [ ] settings.png - Settings screen with language options"
echo "  [ ] widgets.png - Home screen with both widgets"
echo "  [ ] notification.png - Notification with quick action"
echo ""
echo "💡 Tips:"
echo "  - Use light backgrounds for better visibility"
echo "  - Capture different states (empty, with data, etc.)"
echo "  - Keep consistent aspect ratio"
echo "  - Recommended resolution: 1080x2400 or similar"
echo ""
echo "After capturing, resize if needed:"
echo "  sips -Z 800 screenshots/*.png  # Resize to max 800px"
echo ""
