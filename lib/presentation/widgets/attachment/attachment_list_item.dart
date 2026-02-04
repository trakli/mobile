import 'package:trakli/domain/entities/media_file_entity.dart';

/// Sealed type for one attachment in a list: existing (saved) vs new local (just selected).
/// Distinguishes "saved with no id" from "new" by variant, not by id.
sealed class AttachmentListItem {
  const AttachmentListItem();

  String get path;
  int? get mediaId;
  bool get isNewlyAdded;
}

/// Attachment that already exists (from server / transaction.files).
/// Handles attachments yet to be saved on the server but saved locally.
class ExistingAttachment extends AttachmentListItem {
  const ExistingAttachment(this.media);

  final MediaFileEntity media;

  @override
  String get path => media.path;

  @override
  int? get mediaId => media.id;

  @override
  bool get isNewlyAdded => false;
}

/// Attachment just selected (camera / gallery / file picker), not yet saved.
class NewLocalAttachment extends AttachmentListItem {
  const NewLocalAttachment(this.path);

  @override
  final String path;

  @override
  int? get mediaId => null;

  @override
  bool get isNewlyAdded => true;
}
