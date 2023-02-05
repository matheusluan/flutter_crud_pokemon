import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import './pokemon.dart';

class DatabaseHelper {
  static const _dbName = 'pokemonsdb.db';
  static const _dbVersion = 1;

  //singleton
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    // if (_database == null) {
    //    _database = await _initDatabase();
    // }
    //versão curta:
    _database ??= await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), _dbName);

    return await openDatabase(dbPath,
        version: _dbVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Pokemon.tablePokemon}(
        ${Pokemon.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Pokemon.colNome} TEXT NOT NULL,
        ${Pokemon.colTipo} TEXT NOT NULL,
        ${Pokemon.colHabilidade} TEXT NOT NULL,
        ${Pokemon.colImagem} TEXT NOT NULL)''');
  }

  Future<int> inserirPokemon(Pokemon pokemon) async {
    Database db = await database;
    return await db.insert(Pokemon.tablePokemon, pokemon.toMap());
  }

  Future<int> atualizarPokemon(Pokemon contato) async {
    Database db = await database;
    return await db.update(Pokemon.tablePokemon, contato.toMap(),
        where: '${Pokemon.colId} = ?', whereArgs: [contato.id]);
  }

  Future<int> excluirPokemon(int id) async {
    Database db = await database;
    return await db.delete(Pokemon.tablePokemon,
        where: '${Pokemon.colId} = ?', whereArgs: [id]);
  }

  Future<List<Pokemon>> listarPokemons() async {
    Database db = await database;
    List<Map<String, dynamic>> pokemons = await db.query(Pokemon.tablePokemon);
    return pokemons.isEmpty
        ? []
        : pokemons.map((e) => Pokemon.fromMap(e)).toList();
  }
}
