import 'package:flutter_crud_pokemon/model/pokemonAPI.dart';

abstract class PokemonRepository {
  Future<PokemonModel> getPokemon(String nome);
}
