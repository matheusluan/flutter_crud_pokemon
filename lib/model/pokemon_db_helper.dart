import './pokemon.dart';
import './database_helper.dart';
import 'package:sqflite/sqflite.dart';

class PokemonDbHelper {
  static final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<int> inserirPokemon(Pokemon pokemon) async {
    Database db = await dbHelper.database;
    return await db.insert(Pokemon.tablePokemon, pokemon.toMap());
  }

  Future<int> atualizarPokemon(Pokemon pokemon) async {
    Database db = await dbHelper.database;
    return await db.update(Pokemon.tablePokemon, pokemon.toMap(),
        where: '${Pokemon.colId} = ?', whereArgs: [pokemon.id]);
  }

  Future<int> excluirPokemon(int id) async {
    Database db = await dbHelper.database;
    return await db.delete(Pokemon.tablePokemon,
        where: '${Pokemon.colId} = ?', whereArgs: [id]);
  }

  Future<List<Pokemon>> listarPokemons() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> pokemons = await db.query(Pokemon.tablePokemon);
    return pokemons.isEmpty
        ? []
        : pokemons.map((e) => Pokemon.fromMap(e)).toList();
  }
}
