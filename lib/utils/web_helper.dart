// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

void openMidtransSnap(String snapUrl) {
  html.window.open(snapUrl, '_blank');
}
