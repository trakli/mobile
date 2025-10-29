import 'package:flutter/material.dart';

class EmptyStateModel {
  final IconData icon;
  final String title;
  final String? title1;
  final String description;
  final String? description1;
  final List<String> quickStartSteps;
  final List<Steps>? quickSteps;
  final String buttonText;
  final String? buttonText1;
  final String? tipText;

  const EmptyStateModel({
    required this.icon,
    required this.title,
    this.title1,
    required this.description,
    this.description1,
    required this.quickStartSteps,
    this.quickSteps,
    required this.buttonText,
    this.buttonText1,
    this.tipText,
  });
}

class Steps {
  final IconData icon;
  final String description;

  const Steps({
    required this.icon,
    required this.description,
  });
}
