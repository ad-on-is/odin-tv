#!/bin/bash

adb connect $(landevice Fire):5555 && adb -s $(landevice Fire):5555 install build/app/outputs/flutter-apk/app-release.apk