// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class IotSharpProfileData extends DataClass
    implements Insertable<IotSharpProfileData> {
  final int id;
  final String? profilename;
  final String? serverurl;
  final int? serverport;
  final String? username;
  final String? token;
  final DateTime? addDate;
  const IotSharpProfileData(
      {required this.id,
      this.profilename,
      this.serverurl,
      this.serverport,
      this.username,
      this.token,
      this.addDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || profilename != null) {
      map['profilename'] = Variable<String>(profilename);
    }
    if (!nullToAbsent || serverurl != null) {
      map['serverurl'] = Variable<String>(serverurl);
    }
    if (!nullToAbsent || serverport != null) {
      map['serverport'] = Variable<int>(serverport);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    if (!nullToAbsent || addDate != null) {
      map['add_date'] = Variable<DateTime>(addDate);
    }
    return map;
  }

  IotSharpProfileCompanion toCompanion(bool nullToAbsent) {
    return IotSharpProfileCompanion(
      id: Value(id),
      profilename: profilename == null && nullToAbsent
          ? const Value.absent()
          : Value(profilename),
      serverurl: serverurl == null && nullToAbsent
          ? const Value.absent()
          : Value(serverurl),
      serverport: serverport == null && nullToAbsent
          ? const Value.absent()
          : Value(serverport),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      addDate: addDate == null && nullToAbsent
          ? const Value.absent()
          : Value(addDate),
    );
  }

  factory IotSharpProfileData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IotSharpProfileData(
      id: serializer.fromJson<int>(json['id']),
      profilename: serializer.fromJson<String?>(json['profilename']),
      serverurl: serializer.fromJson<String?>(json['serverurl']),
      serverport: serializer.fromJson<int?>(json['serverport']),
      username: serializer.fromJson<String?>(json['username']),
      token: serializer.fromJson<String?>(json['token']),
      addDate: serializer.fromJson<DateTime?>(json['addDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profilename': serializer.toJson<String?>(profilename),
      'serverurl': serializer.toJson<String?>(serverurl),
      'serverport': serializer.toJson<int?>(serverport),
      'username': serializer.toJson<String?>(username),
      'token': serializer.toJson<String?>(token),
      'addDate': serializer.toJson<DateTime?>(addDate),
    };
  }

  IotSharpProfileData copyWith(
          {int? id,
          Value<String?> profilename = const Value.absent(),
          Value<String?> serverurl = const Value.absent(),
          Value<int?> serverport = const Value.absent(),
          Value<String?> username = const Value.absent(),
          Value<String?> token = const Value.absent(),
          Value<DateTime?> addDate = const Value.absent()}) =>
      IotSharpProfileData(
        id: id ?? this.id,
        profilename: profilename.present ? profilename.value : this.profilename,
        serverurl: serverurl.present ? serverurl.value : this.serverurl,
        serverport: serverport.present ? serverport.value : this.serverport,
        username: username.present ? username.value : this.username,
        token: token.present ? token.value : this.token,
        addDate: addDate.present ? addDate.value : this.addDate,
      );
  @override
  String toString() {
    return (StringBuffer('IotSharpProfileData(')
          ..write('id: $id, ')
          ..write('profilename: $profilename, ')
          ..write('serverurl: $serverurl, ')
          ..write('serverport: $serverport, ')
          ..write('username: $username, ')
          ..write('token: $token, ')
          ..write('addDate: $addDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, profilename, serverurl, serverport, username, token, addDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IotSharpProfileData &&
          other.id == this.id &&
          other.profilename == this.profilename &&
          other.serverurl == this.serverurl &&
          other.serverport == this.serverport &&
          other.username == this.username &&
          other.token == this.token &&
          other.addDate == this.addDate);
}

class IotSharpProfileCompanion extends UpdateCompanion<IotSharpProfileData> {
  final Value<int> id;
  final Value<String?> profilename;
  final Value<String?> serverurl;
  final Value<int?> serverport;
  final Value<String?> username;
  final Value<String?> token;
  final Value<DateTime?> addDate;
  const IotSharpProfileCompanion({
    this.id = const Value.absent(),
    this.profilename = const Value.absent(),
    this.serverurl = const Value.absent(),
    this.serverport = const Value.absent(),
    this.username = const Value.absent(),
    this.token = const Value.absent(),
    this.addDate = const Value.absent(),
  });
  IotSharpProfileCompanion.insert({
    this.id = const Value.absent(),
    this.profilename = const Value.absent(),
    this.serverurl = const Value.absent(),
    this.serverport = const Value.absent(),
    this.username = const Value.absent(),
    this.token = const Value.absent(),
    this.addDate = const Value.absent(),
  });
  static Insertable<IotSharpProfileData> custom({
    Expression<int>? id,
    Expression<String>? profilename,
    Expression<String>? serverurl,
    Expression<int>? serverport,
    Expression<String>? username,
    Expression<String>? token,
    Expression<DateTime>? addDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profilename != null) 'profilename': profilename,
      if (serverurl != null) 'serverurl': serverurl,
      if (serverport != null) 'serverport': serverport,
      if (username != null) 'username': username,
      if (token != null) 'token': token,
      if (addDate != null) 'add_date': addDate,
    });
  }

  IotSharpProfileCompanion copyWith(
      {Value<int>? id,
      Value<String?>? profilename,
      Value<String?>? serverurl,
      Value<int?>? serverport,
      Value<String?>? username,
      Value<String?>? token,
      Value<DateTime?>? addDate}) {
    return IotSharpProfileCompanion(
      id: id ?? this.id,
      profilename: profilename ?? this.profilename,
      serverurl: serverurl ?? this.serverurl,
      serverport: serverport ?? this.serverport,
      username: username ?? this.username,
      token: token ?? this.token,
      addDate: addDate ?? this.addDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profilename.present) {
      map['profilename'] = Variable<String>(profilename.value);
    }
    if (serverurl.present) {
      map['serverurl'] = Variable<String>(serverurl.value);
    }
    if (serverport.present) {
      map['serverport'] = Variable<int>(serverport.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (addDate.present) {
      map['add_date'] = Variable<DateTime>(addDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IotSharpProfileCompanion(')
          ..write('id: $id, ')
          ..write('profilename: $profilename, ')
          ..write('serverurl: $serverurl, ')
          ..write('serverport: $serverport, ')
          ..write('username: $username, ')
          ..write('token: $token, ')
          ..write('addDate: $addDate')
          ..write(')'))
        .toString();
  }
}

class $IotSharpProfileTable extends IotSharpProfile
    with TableInfo<$IotSharpProfileTable, IotSharpProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IotSharpProfileTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _profilenameMeta =
      const VerificationMeta('profilename');
  @override
  late final GeneratedColumn<String> profilename = GeneratedColumn<String>(
      'profilename', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  final VerificationMeta _serverurlMeta = const VerificationMeta('serverurl');
  @override
  late final GeneratedColumn<String> serverurl = GeneratedColumn<String>(
      'serverurl', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  final VerificationMeta _serverportMeta = const VerificationMeta('serverport');
  @override
  late final GeneratedColumn<int> serverport = GeneratedColumn<int>(
      'serverport', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _usernameMeta = const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 2048),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  final VerificationMeta _addDateMeta = const VerificationMeta('addDate');
  @override
  late final GeneratedColumn<DateTime> addDate = GeneratedColumn<DateTime>(
      'add_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, profilename, serverurl, serverport, username, token, addDate];
  @override
  String get aliasedName => _alias ?? 'iot_sharp_profile';
  @override
  String get actualTableName => 'iot_sharp_profile';
  @override
  VerificationContext validateIntegrity(
      Insertable<IotSharpProfileData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profilename')) {
      context.handle(
          _profilenameMeta,
          profilename.isAcceptableOrUnknown(
              data['profilename']!, _profilenameMeta));
    }
    if (data.containsKey('serverurl')) {
      context.handle(_serverurlMeta,
          serverurl.isAcceptableOrUnknown(data['serverurl']!, _serverurlMeta));
    }
    if (data.containsKey('serverport')) {
      context.handle(
          _serverportMeta,
          serverport.isAcceptableOrUnknown(
              data['serverport']!, _serverportMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    }
    if (data.containsKey('add_date')) {
      context.handle(_addDateMeta,
          addDate.isAcceptableOrUnknown(data['add_date']!, _addDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IotSharpProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IotSharpProfileData(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profilename: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}profilename']),
      serverurl: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}serverurl']),
      serverport: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}serverport']),
      username: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}username']),
      token: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}token']),
      addDate: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}add_date']),
    );
  }

  @override
  $IotSharpProfileTable createAlias(String alias) {
    return $IotSharpProfileTable(attachedDatabase, alias);
  }
}

abstract class _$IOTDatabase extends GeneratedDatabase {
  _$IOTDatabase(QueryExecutor e) : super(e);
  late final $IotSharpProfileTable iotSharpProfile =
      $IotSharpProfileTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [iotSharpProfile];
}
