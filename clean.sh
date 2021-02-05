#!/usr/bin/env bash

find ./ -type f -name "*.g.dart" -delete
find ./ -type f -name "*.chopper.dart" -delete
flutter clean
flutter pub get
flutter packages pub run build_runner build -v --delete-conflicting-outputs