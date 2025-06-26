#!/bin/bash

archivo="$1"

# Obtener ruta absoluta del archivo y su carpeta
archivo_absoluto=$(realpath "$archivo")
carpeta_base=$(dirname "$archivo_absoluto")
nombre=$(basename "$archivo_absoluto" .s)
objeto="${carpeta_base}/${nombre}.o"
salida="${carpeta_base}/${nombre}"

# Compilar, enlazar y ejecutar desde su propia carpeta
aarch64-linux-gnu-as -o "$objeto" "$archivo_absoluto" &&
aarch64-linux-gnu-ld -o "$salida" "$objeto" &&
qemu-aarch64 "$salida"

echo "Return code: $?"
