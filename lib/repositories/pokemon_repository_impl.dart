import 'package:dio/dio.dart';
import '../model/pokemonAPI.dart';
import 'pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  @override
  Future<PokemonModel> getPokemon(String pokemon) async {
    try {
      final result = await Dio().get('https://pokeapi.co/api/v2/pokemon/$pokemon');   
      return PokemonModel.fromMap(result.data); 
    } catch (e) {
      throw Exception('Erro na busca do Pokemon:$pokemon');
    }
  }
}
