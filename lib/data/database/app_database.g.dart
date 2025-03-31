// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<String> rev = GeneratedColumn<String>(
      'rev', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1'));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtLocalMeta =
      const VerificationMeta('createdAtLocal');
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>('created_at_local', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtLocalMeta =
      const VerificationMeta('updatedAtLocal');
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>('updated_at_local', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtServerMeta =
      const VerificationMeta('createdAtServer');
  @override
  late final GeneratedColumn<DateTime> createdAtServer =
      GeneratedColumn<DateTime>('created_at_server', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtServerMeta =
      const VerificationMeta('updatedAtServer');
  @override
  late final GeneratedColumn<DateTime> updatedAtServer =
      GeneratedColumn<DateTime>('updated_at_server', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtLocalMeta =
      const VerificationMeta('deletedAtLocal');
  @override
  late final GeneratedColumn<DateTime> deletedAtLocal =
      GeneratedColumn<DateTime>('deleted_at_local', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        rev,
        id,
        serverId,
        amount,
        createdAtLocal,
        updatedAtLocal,
        createdAtServer,
        updatedAtServer,
        category,
        description,
        deletedAtLocal,
        lastSyncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rev')) {
      context.handle(
          _revMeta, rev.isAcceptableOrUnknown(data['rev']!, _revMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
          _createdAtLocalMeta,
          createdAtLocal.isAcceptableOrUnknown(
              data['created_at_local']!, _createdAtLocalMeta));
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
          _updatedAtLocalMeta,
          updatedAtLocal.isAcceptableOrUnknown(
              data['updated_at_local']!, _updatedAtLocalMeta));
    }
    if (data.containsKey('created_at_server')) {
      context.handle(
          _createdAtServerMeta,
          createdAtServer.isAcceptableOrUnknown(
              data['created_at_server']!, _createdAtServerMeta));
    }
    if (data.containsKey('updated_at_server')) {
      context.handle(
          _updatedAtServerMeta,
          updatedAtServer.isAcceptableOrUnknown(
              data['updated_at_server']!, _updatedAtServerMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('deleted_at_local')) {
      context.handle(
          _deletedAtLocalMeta,
          deletedAtLocal.isAcceptableOrUnknown(
              data['deleted_at_local']!, _deletedAtLocalMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      rev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rev'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      createdAtLocal: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at_local'])!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}updated_at_local'])!,
      createdAtServer: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at_server']),
      updatedAtServer: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}updated_at_server']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      deletedAtLocal: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}deleted_at_local']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String rev;
  final String id;
  final String? serverId;
  final double amount;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? createdAtServer;
  final DateTime? updatedAtServer;
  final String category;
  final String? description;
  final DateTime? deletedAtLocal;
  final DateTime? lastSyncedAt;
  const Transaction(
      {required this.rev,
      required this.id,
      this.serverId,
      required this.amount,
      required this.createdAtLocal,
      required this.updatedAtLocal,
      this.createdAtServer,
      this.updatedAtServer,
      required this.category,
      this.description,
      this.deletedAtLocal,
      this.lastSyncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rev'] = Variable<String>(rev);
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['amount'] = Variable<double>(amount);
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || createdAtServer != null) {
      map['created_at_server'] = Variable<DateTime>(createdAtServer);
    }
    if (!nullToAbsent || updatedAtServer != null) {
      map['updated_at_server'] = Variable<DateTime>(updatedAtServer);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || deletedAtLocal != null) {
      map['deleted_at_local'] = Variable<DateTime>(deletedAtLocal);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      rev: Value(rev),
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      amount: Value(amount),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      createdAtServer: createdAtServer == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAtServer),
      updatedAtServer: updatedAtServer == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtServer),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      deletedAtLocal: deletedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtLocal),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      rev: serializer.fromJson<String>(json['rev']),
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      amount: serializer.fromJson<double>(json['amount']),
      createdAtLocal: serializer.fromJson<DateTime>(json['created_at_local']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updated_at_local']),
      createdAtServer:
          serializer.fromJson<DateTime?>(json['created_at_server']),
      updatedAtServer:
          serializer.fromJson<DateTime?>(json['updated_at_server']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      deletedAtLocal: serializer.fromJson<DateTime?>(json['deleted_at_local']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['last_synced_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rev': serializer.toJson<String>(rev),
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'amount': serializer.toJson<double>(amount),
      'created_at_local': serializer.toJson<DateTime>(createdAtLocal),
      'updated_at_local': serializer.toJson<DateTime>(updatedAtLocal),
      'created_at_server': serializer.toJson<DateTime?>(createdAtServer),
      'updated_at_server': serializer.toJson<DateTime?>(updatedAtServer),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'deleted_at_local': serializer.toJson<DateTime?>(deletedAtLocal),
      'last_synced_at': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  Transaction copyWith(
          {String? rev,
          String? id,
          Value<String?> serverId = const Value.absent(),
          double? amount,
          DateTime? createdAtLocal,
          DateTime? updatedAtLocal,
          Value<DateTime?> createdAtServer = const Value.absent(),
          Value<DateTime?> updatedAtServer = const Value.absent(),
          String? category,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> deletedAtLocal = const Value.absent(),
          Value<DateTime?> lastSyncedAt = const Value.absent()}) =>
      Transaction(
        rev: rev ?? this.rev,
        id: id ?? this.id,
        serverId: serverId.present ? serverId.value : this.serverId,
        amount: amount ?? this.amount,
        createdAtLocal: createdAtLocal ?? this.createdAtLocal,
        updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
        createdAtServer: createdAtServer.present
            ? createdAtServer.value
            : this.createdAtServer,
        updatedAtServer: updatedAtServer.present
            ? updatedAtServer.value
            : this.updatedAtServer,
        category: category ?? this.category,
        description: description.present ? description.value : this.description,
        deletedAtLocal:
            deletedAtLocal.present ? deletedAtLocal.value : this.deletedAtLocal,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      rev: data.rev.present ? data.rev.value : this.rev,
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      createdAtServer: data.createdAtServer.present
          ? data.createdAtServer.value
          : this.createdAtServer,
      updatedAtServer: data.updatedAtServer.present
          ? data.updatedAtServer.value
          : this.updatedAtServer,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      deletedAtLocal: data.deletedAtLocal.present
          ? data.deletedAtLocal.value
          : this.deletedAtLocal,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('amount: $amount, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('createdAtServer: $createdAtServer, ')
          ..write('updatedAtServer: $updatedAtServer, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('deletedAtLocal: $deletedAtLocal, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      rev,
      id,
      serverId,
      amount,
      createdAtLocal,
      updatedAtLocal,
      createdAtServer,
      updatedAtServer,
      category,
      description,
      deletedAtLocal,
      lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.rev == this.rev &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.amount == this.amount &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.createdAtServer == this.createdAtServer &&
          other.updatedAtServer == this.updatedAtServer &&
          other.category == this.category &&
          other.description == this.description &&
          other.deletedAtLocal == this.deletedAtLocal &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> rev;
  final Value<String> id;
  final Value<String?> serverId;
  final Value<double> amount;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> createdAtServer;
  final Value<DateTime?> updatedAtServer;
  final Value<String> category;
  final Value<String?> description;
  final Value<DateTime?> deletedAtLocal;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.rev = const Value.absent(),
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.createdAtServer = const Value.absent(),
    this.updatedAtServer = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.deletedAtLocal = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.rev = const Value.absent(),
    required String id,
    this.serverId = const Value.absent(),
    required double amount,
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.createdAtServer = const Value.absent(),
    this.updatedAtServer = const Value.absent(),
    required String category,
    this.description = const Value.absent(),
    this.deletedAtLocal = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        amount = Value(amount),
        category = Value(category);
  static Insertable<Transaction> custom({
    Expression<String>? rev,
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<double>? amount,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? createdAtServer,
    Expression<DateTime>? updatedAtServer,
    Expression<String>? category,
    Expression<String>? description,
    Expression<DateTime>? deletedAtLocal,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rev != null) 'rev': rev,
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (amount != null) 'amount': amount,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (createdAtServer != null) 'created_at_server': createdAtServer,
      if (updatedAtServer != null) 'updated_at_server': updatedAtServer,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (deletedAtLocal != null) 'deleted_at_local': deletedAtLocal,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? rev,
      Value<String>? id,
      Value<String?>? serverId,
      Value<double>? amount,
      Value<DateTime>? createdAtLocal,
      Value<DateTime>? updatedAtLocal,
      Value<DateTime?>? createdAtServer,
      Value<DateTime?>? updatedAtServer,
      Value<String>? category,
      Value<String?>? description,
      Value<DateTime?>? deletedAtLocal,
      Value<DateTime?>? lastSyncedAt,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      rev: rev ?? this.rev,
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      amount: amount ?? this.amount,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      createdAtServer: createdAtServer ?? this.createdAtServer,
      updatedAtServer: updatedAtServer ?? this.updatedAtServer,
      category: category ?? this.category,
      description: description ?? this.description,
      deletedAtLocal: deletedAtLocal ?? this.deletedAtLocal,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rev.present) {
      map['rev'] = Variable<String>(rev.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (createdAtServer.present) {
      map['created_at_server'] = Variable<DateTime>(createdAtServer.value);
    }
    if (updatedAtServer.present) {
      map['updated_at_server'] = Variable<DateTime>(updatedAtServer.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (deletedAtLocal.present) {
      map['deleted_at_local'] = Variable<DateTime>(deletedAtLocal.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('rev: $rev, ')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('amount: $amount, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('createdAtServer: $createdAtServer, ')
          ..write('updatedAtServer: $updatedAtServer, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('deletedAtLocal: $deletedAtLocal, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalChangesTable extends LocalChanges
    with TableInfo<$LocalChangesTable, LocalChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityRevMeta =
      const VerificationMeta('entityRev');
  @override
  late final GeneratedColumn<String> entityRev = GeneratedColumn<String>(
      'entity_rev', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'));
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      data = GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $LocalChangesTable.$converterdata);
  static const VerificationMeta _createAtMeta =
      const VerificationMeta('createAt');
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _concludedMeta =
      const VerificationMeta('concluded');
  @override
  late final GeneratedColumn<bool> concluded = GeneratedColumn<bool>(
      'concluded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("concluded" IN (0, 1))'));
  static const VerificationMeta _concludedMomentMeta =
      const VerificationMeta('concludedMoment');
  @override
  late final GeneratedColumn<DateTime> concludedMoment =
      GeneratedColumn<DateTime>('concluded_moment', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dismissedMeta =
      const VerificationMeta('dismissed');
  @override
  late final GeneratedColumn<bool> dismissed = GeneratedColumn<bool>(
      'dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dismissed" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        entityType,
        entityId,
        entityRev,
        deleted,
        data,
        createAt,
        concluded,
        concludedMoment,
        error,
        dismissed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_changes';
  @override
  VerificationContext validateIntegrity(Insertable<LocalChange> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_rev')) {
      context.handle(_entityRevMeta,
          entityRev.isAcceptableOrUnknown(data['entity_rev']!, _entityRevMeta));
    } else if (isInserting) {
      context.missing(_entityRevMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    if (data.containsKey('create_at')) {
      context.handle(_createAtMeta,
          createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta));
    } else if (isInserting) {
      context.missing(_createAtMeta);
    }
    if (data.containsKey('concluded')) {
      context.handle(_concludedMeta,
          concluded.isAcceptableOrUnknown(data['concluded']!, _concludedMeta));
    } else if (isInserting) {
      context.missing(_concludedMeta);
    }
    if (data.containsKey('concluded_moment')) {
      context.handle(
          _concludedMomentMeta,
          concludedMoment.isAcceptableOrUnknown(
              data['concluded_moment']!, _concludedMomentMeta));
    }
    if (data.containsKey('error')) {
      context.handle(
          _errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    if (data.containsKey('dismissed')) {
      context.handle(_dismissedMeta,
          dismissed.isAcceptableOrUnknown(data['dismissed']!, _dismissedMeta));
    } else if (isInserting) {
      context.missing(_dismissedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId, entityType};
  @override
  LocalChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalChange(
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      entityRev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_rev'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      data: $LocalChangesTable.$converterdata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at'])!,
      concluded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}concluded'])!,
      concludedMoment: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}concluded_moment']),
      error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error']),
      dismissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dismissed'])!,
    );
  }

  @override
  $LocalChangesTable createAlias(String alias) {
    return $LocalChangesTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterdata =
      const JsonMapConverter();
}

class LocalChange extends DataClass implements Insertable<LocalChange> {
  final String entityType;
  final String entityId;
  final String entityRev;
  final bool deleted;
  final Map<String, dynamic> data;
  final DateTime createAt;
  final bool concluded;
  final DateTime? concludedMoment;
  final String? error;
  final bool dismissed;
  const LocalChange(
      {required this.entityType,
      required this.entityId,
      required this.entityRev,
      required this.deleted,
      required this.data,
      required this.createAt,
      required this.concluded,
      this.concludedMoment,
      this.error,
      required this.dismissed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['entity_rev'] = Variable<String>(entityRev);
    map['deleted'] = Variable<bool>(deleted);
    {
      map['data'] =
          Variable<String>($LocalChangesTable.$converterdata.toSql(data));
    }
    map['create_at'] = Variable<DateTime>(createAt);
    map['concluded'] = Variable<bool>(concluded);
    if (!nullToAbsent || concludedMoment != null) {
      map['concluded_moment'] = Variable<DateTime>(concludedMoment);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['dismissed'] = Variable<bool>(dismissed);
    return map;
  }

  LocalChangesCompanion toCompanion(bool nullToAbsent) {
    return LocalChangesCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      entityRev: Value(entityRev),
      deleted: Value(deleted),
      data: Value(data),
      createAt: Value(createAt),
      concluded: Value(concluded),
      concludedMoment: concludedMoment == null && nullToAbsent
          ? const Value.absent()
          : Value(concludedMoment),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
      dismissed: Value(dismissed),
    );
  }

  factory LocalChange.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalChange(
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      entityRev: serializer.fromJson<String>(json['entityRev']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      data: serializer.fromJson<Map<String, dynamic>>(json['data']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
      concluded: serializer.fromJson<bool>(json['concluded']),
      concludedMoment: serializer.fromJson<DateTime?>(json['concludedMoment']),
      error: serializer.fromJson<String?>(json['error']),
      dismissed: serializer.fromJson<bool>(json['dismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'entityRev': serializer.toJson<String>(entityRev),
      'deleted': serializer.toJson<bool>(deleted),
      'data': serializer.toJson<Map<String, dynamic>>(data),
      'createAt': serializer.toJson<DateTime>(createAt),
      'concluded': serializer.toJson<bool>(concluded),
      'concludedMoment': serializer.toJson<DateTime?>(concludedMoment),
      'error': serializer.toJson<String?>(error),
      'dismissed': serializer.toJson<bool>(dismissed),
    };
  }

  LocalChange copyWith(
          {String? entityType,
          String? entityId,
          String? entityRev,
          bool? deleted,
          Map<String, dynamic>? data,
          DateTime? createAt,
          bool? concluded,
          Value<DateTime?> concludedMoment = const Value.absent(),
          Value<String?> error = const Value.absent(),
          bool? dismissed}) =>
      LocalChange(
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        entityRev: entityRev ?? this.entityRev,
        deleted: deleted ?? this.deleted,
        data: data ?? this.data,
        createAt: createAt ?? this.createAt,
        concluded: concluded ?? this.concluded,
        concludedMoment: concludedMoment.present
            ? concludedMoment.value
            : this.concludedMoment,
        error: error.present ? error.value : this.error,
        dismissed: dismissed ?? this.dismissed,
      );
  LocalChange copyWithCompanion(LocalChangesCompanion data) {
    return LocalChange(
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityRev: data.entityRev.present ? data.entityRev.value : this.entityRev,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      data: data.data.present ? data.data.value : this.data,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
      concluded: data.concluded.present ? data.concluded.value : this.concluded,
      concludedMoment: data.concludedMoment.present
          ? data.concludedMoment.value
          : this.concludedMoment,
      error: data.error.present ? data.error.value : this.error,
      dismissed: data.dismissed.present ? data.dismissed.value : this.dismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalChange(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityRev: $entityRev, ')
          ..write('deleted: $deleted, ')
          ..write('data: $data, ')
          ..write('createAt: $createAt, ')
          ..write('concluded: $concluded, ')
          ..write('concludedMoment: $concludedMoment, ')
          ..write('error: $error, ')
          ..write('dismissed: $dismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, entityId, entityRev, deleted,
      data, createAt, concluded, concludedMoment, error, dismissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalChange &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.entityRev == this.entityRev &&
          other.deleted == this.deleted &&
          other.data == this.data &&
          other.createAt == this.createAt &&
          other.concluded == this.concluded &&
          other.concludedMoment == this.concludedMoment &&
          other.error == this.error &&
          other.dismissed == this.dismissed);
}

class LocalChangesCompanion extends UpdateCompanion<LocalChange> {
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> entityRev;
  final Value<bool> deleted;
  final Value<Map<String, dynamic>> data;
  final Value<DateTime> createAt;
  final Value<bool> concluded;
  final Value<DateTime?> concludedMoment;
  final Value<String?> error;
  final Value<bool> dismissed;
  final Value<int> rowid;
  const LocalChangesCompanion({
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.entityRev = const Value.absent(),
    this.deleted = const Value.absent(),
    this.data = const Value.absent(),
    this.createAt = const Value.absent(),
    this.concluded = const Value.absent(),
    this.concludedMoment = const Value.absent(),
    this.error = const Value.absent(),
    this.dismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalChangesCompanion.insert({
    required String entityType,
    required String entityId,
    required String entityRev,
    required bool deleted,
    required Map<String, dynamic> data,
    required DateTime createAt,
    required bool concluded,
    this.concludedMoment = const Value.absent(),
    this.error = const Value.absent(),
    required bool dismissed,
    this.rowid = const Value.absent(),
  })  : entityType = Value(entityType),
        entityId = Value(entityId),
        entityRev = Value(entityRev),
        deleted = Value(deleted),
        data = Value(data),
        createAt = Value(createAt),
        concluded = Value(concluded),
        dismissed = Value(dismissed);
  static Insertable<LocalChange> custom({
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? entityRev,
    Expression<bool>? deleted,
    Expression<String>? data,
    Expression<DateTime>? createAt,
    Expression<bool>? concluded,
    Expression<DateTime>? concludedMoment,
    Expression<String>? error,
    Expression<bool>? dismissed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (entityRev != null) 'entity_rev': entityRev,
      if (deleted != null) 'deleted': deleted,
      if (data != null) 'data': data,
      if (createAt != null) 'create_at': createAt,
      if (concluded != null) 'concluded': concluded,
      if (concludedMoment != null) 'concluded_moment': concludedMoment,
      if (error != null) 'error': error,
      if (dismissed != null) 'dismissed': dismissed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalChangesCompanion copyWith(
      {Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? entityRev,
      Value<bool>? deleted,
      Value<Map<String, dynamic>>? data,
      Value<DateTime>? createAt,
      Value<bool>? concluded,
      Value<DateTime?>? concludedMoment,
      Value<String?>? error,
      Value<bool>? dismissed,
      Value<int>? rowid}) {
    return LocalChangesCompanion(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      entityRev: entityRev ?? this.entityRev,
      deleted: deleted ?? this.deleted,
      data: data ?? this.data,
      createAt: createAt ?? this.createAt,
      concluded: concluded ?? this.concluded,
      concludedMoment: concludedMoment ?? this.concludedMoment,
      error: error ?? this.error,
      dismissed: dismissed ?? this.dismissed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityRev.present) {
      map['entity_rev'] = Variable<String>(entityRev.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (data.present) {
      map['data'] =
          Variable<String>($LocalChangesTable.$converterdata.toSql(data.value));
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    if (concluded.present) {
      map['concluded'] = Variable<bool>(concluded.value);
    }
    if (concludedMoment.present) {
      map['concluded_moment'] = Variable<DateTime>(concludedMoment.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (dismissed.present) {
      map['dismissed'] = Variable<bool>(dismissed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalChangesCompanion(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityRev: $entityRev, ')
          ..write('deleted: $deleted, ')
          ..write('data: $data, ')
          ..write('createAt: $createAt, ')
          ..write('concluded: $concluded, ')
          ..write('concludedMoment: $concludedMoment, ')
          ..write('error: $error, ')
          ..write('dismissed: $dismissed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadatas> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastReceivedChangeIdMeta =
      const VerificationMeta('lastReceivedChangeId');
  @override
  late final GeneratedColumn<String> lastReceivedChangeId =
      GeneratedColumn<String>('last_received_change_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, lastReceivedChangeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetadatas> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_received_change_id')) {
      context.handle(
          _lastReceivedChangeIdMeta,
          lastReceivedChangeId.isAcceptableOrUnknown(
              data['last_received_change_id']!, _lastReceivedChangeIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMetadatas map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadatas(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lastReceivedChangeId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_received_change_id']),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadatas extends DataClass implements Insertable<SyncMetadatas> {
  final int id;
  final String? lastReceivedChangeId;
  const SyncMetadatas({required this.id, this.lastReceivedChangeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastReceivedChangeId != null) {
      map['last_received_change_id'] = Variable<String>(lastReceivedChangeId);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      id: Value(id),
      lastReceivedChangeId: lastReceivedChangeId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReceivedChangeId),
    );
  }

  factory SyncMetadatas.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadatas(
      id: serializer.fromJson<int>(json['id']),
      lastReceivedChangeId:
          serializer.fromJson<String?>(json['lastReceivedChangeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastReceivedChangeId': serializer.toJson<String?>(lastReceivedChangeId),
    };
  }

  SyncMetadatas copyWith(
          {int? id,
          Value<String?> lastReceivedChangeId = const Value.absent()}) =>
      SyncMetadatas(
        id: id ?? this.id,
        lastReceivedChangeId: lastReceivedChangeId.present
            ? lastReceivedChangeId.value
            : this.lastReceivedChangeId,
      );
  SyncMetadatas copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadatas(
      id: data.id.present ? data.id.value : this.id,
      lastReceivedChangeId: data.lastReceivedChangeId.present
          ? data.lastReceivedChangeId.value
          : this.lastReceivedChangeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadatas(')
          ..write('id: $id, ')
          ..write('lastReceivedChangeId: $lastReceivedChangeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastReceivedChangeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadatas &&
          other.id == this.id &&
          other.lastReceivedChangeId == this.lastReceivedChangeId);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadatas> {
  final Value<int> id;
  final Value<String?> lastReceivedChangeId;
  const SyncMetadataCompanion({
    this.id = const Value.absent(),
    this.lastReceivedChangeId = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    this.id = const Value.absent(),
    this.lastReceivedChangeId = const Value.absent(),
  });
  static Insertable<SyncMetadatas> custom({
    Expression<int>? id,
    Expression<String>? lastReceivedChangeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastReceivedChangeId != null)
        'last_received_change_id': lastReceivedChangeId,
    });
  }

  SyncMetadataCompanion copyWith(
      {Value<int>? id, Value<String?>? lastReceivedChangeId}) {
    return SyncMetadataCompanion(
      id: id ?? this.id,
      lastReceivedChangeId: lastReceivedChangeId ?? this.lastReceivedChangeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastReceivedChangeId.present) {
      map['last_received_change_id'] =
          Variable<String>(lastReceivedChangeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('id: $id, ')
          ..write('lastReceivedChangeId: $lastReceivedChangeId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $LocalChangesTable localChanges = $LocalChangesTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [transactions, localChanges, syncMetadata];
}

typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> rev,
  required String id,
  Value<String?> serverId,
  required double amount,
  Value<DateTime> createdAtLocal,
  Value<DateTime> updatedAtLocal,
  Value<DateTime?> createdAtServer,
  Value<DateTime?> updatedAtServer,
  required String category,
  Value<String?> description,
  Value<DateTime?> deletedAtLocal,
  Value<DateTime?> lastSyncedAt,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> rev,
  Value<String> id,
  Value<String?> serverId,
  Value<double> amount,
  Value<DateTime> createdAtLocal,
  Value<DateTime> updatedAtLocal,
  Value<DateTime?> createdAtServer,
  Value<DateTime?> updatedAtServer,
  Value<String> category,
  Value<String?> description,
  Value<DateTime?> deletedAtLocal,
  Value<DateTime?> lastSyncedAt,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
      column: $table.createdAtLocal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
      column: $table.updatedAtLocal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAtServer => $composableBuilder(
      column: $table.createdAtServer,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAtServer => $composableBuilder(
      column: $table.updatedAtServer,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAtLocal => $composableBuilder(
      column: $table.deletedAtLocal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get rev => $composableBuilder(
      column: $table.rev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
      column: $table.createdAtLocal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
      column: $table.updatedAtLocal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAtServer => $composableBuilder(
      column: $table.createdAtServer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAtServer => $composableBuilder(
      column: $table.updatedAtServer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAtLocal => $composableBuilder(
      column: $table.deletedAtLocal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
      column: $table.createdAtLocal, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
      column: $table.updatedAtLocal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtServer => $composableBuilder(
      column: $table.createdAtServer, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtServer => $composableBuilder(
      column: $table.updatedAtServer, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAtLocal => $composableBuilder(
      column: $table.deletedAtLocal, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> rev = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String?> serverId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> createdAtLocal = const Value.absent(),
            Value<DateTime> updatedAtLocal = const Value.absent(),
            Value<DateTime?> createdAtServer = const Value.absent(),
            Value<DateTime?> updatedAtServer = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> deletedAtLocal = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            rev: rev,
            id: id,
            serverId: serverId,
            amount: amount,
            createdAtLocal: createdAtLocal,
            updatedAtLocal: updatedAtLocal,
            createdAtServer: createdAtServer,
            updatedAtServer: updatedAtServer,
            category: category,
            description: description,
            deletedAtLocal: deletedAtLocal,
            lastSyncedAt: lastSyncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> rev = const Value.absent(),
            required String id,
            Value<String?> serverId = const Value.absent(),
            required double amount,
            Value<DateTime> createdAtLocal = const Value.absent(),
            Value<DateTime> updatedAtLocal = const Value.absent(),
            Value<DateTime?> createdAtServer = const Value.absent(),
            Value<DateTime?> updatedAtServer = const Value.absent(),
            required String category,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> deletedAtLocal = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            rev: rev,
            id: id,
            serverId: serverId,
            amount: amount,
            createdAtLocal: createdAtLocal,
            updatedAtLocal: updatedAtLocal,
            createdAtServer: createdAtServer,
            updatedAtServer: updatedAtServer,
            category: category,
            description: description,
            deletedAtLocal: deletedAtLocal,
            lastSyncedAt: lastSyncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;
typedef $$LocalChangesTableCreateCompanionBuilder = LocalChangesCompanion
    Function({
  required String entityType,
  required String entityId,
  required String entityRev,
  required bool deleted,
  required Map<String, dynamic> data,
  required DateTime createAt,
  required bool concluded,
  Value<DateTime?> concludedMoment,
  Value<String?> error,
  required bool dismissed,
  Value<int> rowid,
});
typedef $$LocalChangesTableUpdateCompanionBuilder = LocalChangesCompanion
    Function({
  Value<String> entityType,
  Value<String> entityId,
  Value<String> entityRev,
  Value<bool> deleted,
  Value<Map<String, dynamic>> data,
  Value<DateTime> createAt,
  Value<bool> concluded,
  Value<DateTime?> concludedMoment,
  Value<String?> error,
  Value<bool> dismissed,
  Value<int> rowid,
});

class $$LocalChangesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalChangesTable> {
  $$LocalChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityRev => $composableBuilder(
      column: $table.entityRev, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get data => $composableBuilder(
          column: $table.data,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get concluded => $composableBuilder(
      column: $table.concluded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get concludedMoment => $composableBuilder(
      column: $table.concludedMoment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dismissed => $composableBuilder(
      column: $table.dismissed, builder: (column) => ColumnFilters(column));
}

class $$LocalChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalChangesTable> {
  $$LocalChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityRev => $composableBuilder(
      column: $table.entityRev, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get concluded => $composableBuilder(
      column: $table.concluded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get concludedMoment => $composableBuilder(
      column: $table.concludedMoment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dismissed => $composableBuilder(
      column: $table.dismissed, builder: (column) => ColumnOrderings(column));
}

class $$LocalChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalChangesTable> {
  $$LocalChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityRev =>
      $composableBuilder(column: $table.entityRev, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);

  GeneratedColumn<bool> get concluded =>
      $composableBuilder(column: $table.concluded, builder: (column) => column);

  GeneratedColumn<DateTime> get concludedMoment => $composableBuilder(
      column: $table.concludedMoment, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<bool> get dismissed =>
      $composableBuilder(column: $table.dismissed, builder: (column) => column);
}

class $$LocalChangesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalChangesTable,
    LocalChange,
    $$LocalChangesTableFilterComposer,
    $$LocalChangesTableOrderingComposer,
    $$LocalChangesTableAnnotationComposer,
    $$LocalChangesTableCreateCompanionBuilder,
    $$LocalChangesTableUpdateCompanionBuilder,
    (
      LocalChange,
      BaseReferences<_$AppDatabase, $LocalChangesTable, LocalChange>
    ),
    LocalChange,
    PrefetchHooks Function()> {
  $$LocalChangesTableTableManager(_$AppDatabase db, $LocalChangesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> entityRev = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<Map<String, dynamic>> data = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<bool> concluded = const Value.absent(),
            Value<DateTime?> concludedMoment = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<bool> dismissed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalChangesCompanion(
            entityType: entityType,
            entityId: entityId,
            entityRev: entityRev,
            deleted: deleted,
            data: data,
            createAt: createAt,
            concluded: concluded,
            concludedMoment: concludedMoment,
            error: error,
            dismissed: dismissed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String entityType,
            required String entityId,
            required String entityRev,
            required bool deleted,
            required Map<String, dynamic> data,
            required DateTime createAt,
            required bool concluded,
            Value<DateTime?> concludedMoment = const Value.absent(),
            Value<String?> error = const Value.absent(),
            required bool dismissed,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalChangesCompanion.insert(
            entityType: entityType,
            entityId: entityId,
            entityRev: entityRev,
            deleted: deleted,
            data: data,
            createAt: createAt,
            concluded: concluded,
            concludedMoment: concludedMoment,
            error: error,
            dismissed: dismissed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalChangesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalChangesTable,
    LocalChange,
    $$LocalChangesTableFilterComposer,
    $$LocalChangesTableOrderingComposer,
    $$LocalChangesTableAnnotationComposer,
    $$LocalChangesTableCreateCompanionBuilder,
    $$LocalChangesTableUpdateCompanionBuilder,
    (
      LocalChange,
      BaseReferences<_$AppDatabase, $LocalChangesTable, LocalChange>
    ),
    LocalChange,
    PrefetchHooks Function()>;
typedef $$SyncMetadataTableCreateCompanionBuilder = SyncMetadataCompanion
    Function({
  Value<int> id,
  Value<String?> lastReceivedChangeId,
});
typedef $$SyncMetadataTableUpdateCompanionBuilder = SyncMetadataCompanion
    Function({
  Value<int> id,
  Value<String?> lastReceivedChangeId,
});

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastReceivedChangeId => $composableBuilder(
      column: $table.lastReceivedChangeId,
      builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastReceivedChangeId => $composableBuilder(
      column: $table.lastReceivedChangeId,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastReceivedChangeId => $composableBuilder(
      column: $table.lastReceivedChangeId, builder: (column) => column);
}

class $$SyncMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadatas,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadatas,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadatas>
    ),
    SyncMetadatas,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> lastReceivedChangeId = const Value.absent(),
          }) =>
              SyncMetadataCompanion(
            id: id,
            lastReceivedChangeId: lastReceivedChangeId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> lastReceivedChangeId = const Value.absent(),
          }) =>
              SyncMetadataCompanion.insert(
            id: id,
            lastReceivedChangeId: lastReceivedChangeId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadatas,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadatas,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadatas>
    ),
    SyncMetadatas,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$LocalChangesTableTableManager get localChanges =>
      $$LocalChangesTableTableManager(_db, _db.localChanges);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
