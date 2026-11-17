#!/bin/bash
set -e

echo "[*] Starting Firmware Extraction and Porting Process..."

# التأكد من أننا نعمل داخل مجلد workspace
cd workspace

# التحقق من وجود ملفات الروم المحملة
if [ ! -f "base_firmware.zip" ]; then
    echo "Error: Base firmware zip not found!"
    exit 1
fi

if [ ! -f "port_firmware.zip" ]; then
    echo "Error: Port firmware zip not found!"
    exit 1
fi

# إنشاء مجلدات الاستخراج
mkdir -p base/extracted port/extracted

echo "[*] Extracting Base Firmware (A04)..."
unzip -q base_firmware.zip -d base/extracted

echo "[*] Extracting Port Firmware (A05s)..."
unzip -q port_firmware.zip -d port/extracted

# معالجة واستخراج super.img لروم البورت (A05s)
echo "[*] Processing A05s (Source) super.img..."
cd port/extracted
tar -xf AP_*.tar.md5 super.img.lz4
lz4 -d super.img.lz4 super.img
simg2img super.img super_raw.img
cd ../../

# معالجة واستخراج super.img لروم الأساس (A04)
echo "[*] Processing A04 (Base) super.img..."
cd base/extracted
tar -xf AP_*.tar.md5 super.img.lz4
lz4 -d super.img.lz4 super.img
simg2img super.img super_raw.img
cd ../../

echo "[*] Firmware extraction and raw image conversion completed successfully."

# إنشاء ملف الإخراج التجريبي
echo "Placeholder for ported ROM zip" > output/ROM_Port_A04_OneUI.zip
