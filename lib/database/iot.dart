import 'dart:io';
import 'package:drift/native.dart';
import 'package:iotsharp/util/global.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

part 'iot.g.dart';

class IotSharpProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profilename  => text().nullable().withLength(max: 100)();
  TextColumn get serverurl => text().nullable().withLength(max: 200)();
  IntColumn get serverport => integer().nullable()();
  TextColumn get username  => text().nullable().withLength(max: 100)();
  TextColumn get token => text().nullable().withLength(max: 2048)();
  DateTimeColumn get addDate => dateTime().nullable()();
}


LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.

    if (Platform.isWindows) {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'iotsharp.db'));
      return NativeDatabase(file);
    } else if (Platform.isAndroid) {
      final dbFolder = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'iotsharp.db'));
      return NativeDatabase(file);
    } else if (Platform.isIOS) {
      final dbFolder = await getApplicationSupportDirectory();
      final file = File(p.join(dbFolder.path, 'iotsharp.db'));
      return NativeDatabase(file);
    } else {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'iotsharp.db'));
      return NativeDatabase(file);
    }
  });
}

@DriftDatabase(tables: [
  IotSharpProfile,
])
class IOTDatabase extends _$IOTDatabase {
  IOTDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;


  Future<int> CreateProfile(IotSharpProfileCompanion entry) async {
   var profile=await select(iotSharpProfile).getSingleOrNull();
    if(profile==null){
      return into(iotSharpProfile).insert(entry);
    }else{
      return (update(iotSharpProfile)
        ..where((tbl) => tbl.id.equals(1)))
          .write(entry);
    }

  }


  Future<IotSharpProfileData?> GetProfile() {
    return select(iotSharpProfile).getSingleOrNull();
  }

}

