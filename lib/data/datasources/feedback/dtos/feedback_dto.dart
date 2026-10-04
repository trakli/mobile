import 'package:trakli/domain/entities/feedback_entity.dart';

/// Wire shape of `FeedbackResource`. Only the fields the app shows are read.
class FeedbackDto {
  final int id;
  final String type;
  final String status;
  final String? subject;
  final String message;
  final DateTime? createdAt;

  const FeedbackDto({
    required this.id,
    required this.type,
    required this.status,
    this.subject,
    required this.message,
    this.createdAt,
  });

  factory FeedbackDto.fromJson(Map<String, dynamic> json) => FeedbackDto(
        id: (json['id'] as num).toInt(),
        type: json['type'] as String? ?? 'general',
        status: json['status'] as String? ?? 'new',
        subject: json['subject'] as String?,
        message: json['message'] as String? ?? '',
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      );

  FeedbackEntity toEntity() => FeedbackEntity(
        id: id,
        type: FeedbackType.fromServerKey(type),
        status: status,
        subject: subject,
        message: message,
        createdAt: createdAt?.toLocal(),
      );
}
