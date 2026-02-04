import 'package:flutter/material.dart';

bool isPdfPath(String path) => path.toLowerCase().endsWith('.pdf');

bool isImageAttachmentPath(String path) {
  final ext = path.contains('.') ? path.split('.').last.toLowerCase() : '';
  return ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'webp';
}

IconData iconForAttachmentPath(String path) {
  final ext = path.contains('.') ? path.split('.').last.toLowerCase() : '';
  switch (ext) {
    case 'pdf':
      return Icons.picture_as_pdf;
    default:
      return Icons.insert_drive_file;
  }
}

/// Returns a short display name for an attachment path (filename only).
/// Truncates with "…" when longer than [maxLength]
String displayNameForAttachmentPath(String path, {int maxLength = 10}) {
  final name = path.split(RegExp(r'[/\\]')).last;
  return name.length > maxLength ? '${name.substring(0, maxLength)}…' : name;
}
