#!/bin/bash

# CONFIGURA AQUÍ TU IP Y PUERTO:
PHONE_IP="192.168.1.56"
ADB_PORT="39031"  # Current debugging port from phone

# Revisa si el dispositivo ya está conectado
if adb devices | grep -q "$PHONE_IP"; then
    echo "✅ El dispositivo ya está conectado por ADB."
else
    echo "ℹ️  Intentando conectar a $PHONE_IP:$ADB_PORT ..."
    adb connect "$PHONE_IP:$ADB_PORT"

    # Verificar si la conexión fue exitosa
    if adb devices | grep -q "$PHONE_IP"; then
        echo "✅ Conexión exitosa. Listo para debuggear!"
    else
        echo "⚠️  No se pudo conectar automáticamente."
        echo "👉 Probá hacer 'adb pair $PHONE_IP:<PAIR_PORT>' primero desde el teléfono."
        echo "   Después volvé a correr este script."
    fi
fi