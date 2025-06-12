import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class SembastService {
  static final SembastService _instance = SembastService._internal();
  late Database _db;

  final Map<String, StoreRef<String, Map<String, dynamic>>> _stores = {};

  SembastService._internal();

  factory SembastService() => _instance;

  Future<void> init({String dbName = 'bi.db'}) async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/$dbName';
    _db = await databaseFactoryIo.openDatabase(dbPath);
  }

   /// Get or create a store by name
  StoreRef<String, Map<String, dynamic>> _getStore(String storeName) {
    return _stores.putIfAbsent(
      storeName,
      () => StoreRef<String, Map<String, dynamic>>(storeName),
    );
  }

  /// Write or update a record
  Future<void> set(String storeName, String key, Map<String, dynamic> value) async {
    final store = _getStore(storeName);
    await store.record(key).put(_db, value);
  }

  /// Read a record
  Future<Map<String, dynamic>?> get(String storeName, String key) async {
    final store = _getStore(storeName);
    return await store.record(key).get(_db);
  }

  /// Delete a record
  Future<void> delete(String storeName, String key) async {
    final store = _getStore(storeName);
    await store.record(key).delete(_db);
  }

  /// Clear a whole store
  Future<void> clear(String storeName) async {
    final store = _getStore(storeName);
    await store.delete(_db);
  }

  /// Get all records in a store
  Future<List<Map<String, dynamic>>> getAll(String storeName) async {
    final store = _getStore(storeName);
    final snapshots = await store.find(_db);
    return snapshots.map((e) => e.value).toList();
  }
}