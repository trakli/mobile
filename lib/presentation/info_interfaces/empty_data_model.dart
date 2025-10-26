import 'package:flutter/material.dart';

class EmptyStateModel {
  final IconData icon;
  final String title;
  final String description;
  final List<String> quickStartSteps;
  final String buttonText;
  final String? tipText;

  const EmptyStateModel({
    required this.icon,
    required this.title,
    required this.description,
    required this.quickStartSteps,
    required this.buttonText,
    this.tipText,
  });
}
