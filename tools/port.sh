#!/bin/bash
set -e

echo "[*] Starting True Firmware Porting and Extraction..."

cd workspace

# التحقق من وجود ملفات الفيرموير
if [ ! -f "base_firmware.zip" ] || [ ! -f "port_firmware.zip" ]; then
    echo "Error: Firmware archives missing!"
    exit 1
fi

mkdir -p base/extracted port/extracted

echo "[*] Unpacking base and port zips..."
unzip -q base_firmware.zip -d base/extracted
unzip -q port_firmware.zip -d port/extracted

# معالجة روم A05s (المصدر) واستخراج super.img
echo "[*] Processing A05s super.img..."
cd port/extracted
tar -xf AP_*.tar.md5 super.img.lz4
lz4 -d super.img.lz4 super.img
simg2img super.img super_raw.img

# تفكيك الأقسام عبر lpunpack
mkdir -p unpacked_super
lpunpack super_raw.img unpacked_super/
cd ../../../

# معالجة روم A04 (القاعدة) واستخراج الأقسام الأساسية
echo "[*] Processing A04 super.img..."
cd base/extracted
tar -xf AP_*.tar.md5 super.img.lz4
lz4 -d super.img.lz4 super.img
simg2img super.img super_raw.img
mkdir -p unpacked_super
lpunpack super_raw.img unpacked_super/
cd ../../../

echo "[*] Super partitions unpacked successfully!"

# ضغط الناتج الحقيقي في ملف الإخراج للتحميل
cd workspace
zip -r output/Real_Ported_OneUI_A04.zip base/ port/
echo "[*] Port package generated successfully."
