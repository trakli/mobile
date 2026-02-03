import 'package:drift/drift.dart';

/// Table for media synced from the backend (e.g. transaction attachments).
/// [path] is the primary key and the only required column.
@DataClassName('MediaFile')
class MediaFiles extends Table {
  @override
  String get tableName => 'media_files';

  /// Storage path (e.g. "transactions/19YH5k1aHr4z23UMLCOUs3FS7aCBFB0a7vzaB2k9.png").
  /// Primary key.
  TextColumn get path => text()();

  /// Server-assigned id (optional).
  IntColumn get id => integer().nullable()();

  /// Media type (e.g. "file").
  TextColumn get type => text().nullable()();

  /// Server polymorphic type (e.g. "App\\Models\\Transaction").
  TextColumn get fileableType => text().named('fileable_type').nullable()();

  /// Server polymorphic id (e.g. transaction id on server).
  IntColumn get fileableId => integer().named('fileable_id').nullable()();

  /// Local polymorphic type (e.g. transaction client id or type).
  TextColumn get localFileableType =>
      text().named('local_fileable_type').nullable()();

  /// Local polymorphic id (e.g. transaction client_id).
  TextColumn get localFileableId =>
      text().named('local_fileable_id').nullable()();

  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();

  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {path};
}
