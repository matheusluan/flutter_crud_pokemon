import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../model/pokemon.dart';
import '../model/pokemon_db_helper.dart';

class GridViewPokemon extends StatefulWidget {
  const GridViewPokemon({super.key});

  @override
  State<GridViewPokemon> createState() => _GridViewPokemonState();
}

class _GridViewPokemonState extends State<GridViewPokemon> {

  List<Pokemon> _pokemons = [];
  final PokemonDbHelper _pokemondbHelper = PokemonDbHelper();
  String defaultPlaceholderImageUrl = 'https://pokeapi.co/static/pokeapi_256.3fa72200.png';

   _atualizarListaPokemons() async {
    List<Pokemon> c = await _pokemondbHelper.listarPokemons();
    setState(() {
      _pokemons = c;
    });
  }

 @override
  void initState() {
    super.initState();
    _atualizarListaPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Lista de Pokemons'),
      ),
      //GridView.builder
      body: GridView.builder(
        padding: const EdgeInsets.all(3),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemCount: _pokemons.length,
        itemBuilder: (context, index) {
          return Container(
                    margin:const EdgeInsets.all(5.0),
                    child: Card(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        child: InkWell(                              
                           child: Column(
                                children: <Widget>[
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                      child: Image.network(
                                       _pokemons[index].imagem,
                                        width: 100,
                                        height: 100,
                                        fit:BoxFit.fill  
                                      ),
                                    ),
                                    ListTile(
                                      title: Text( _pokemons[index].nome),
                                      subtitle: Text("${_pokemons[index].tipo} - ${_pokemons[index].habilidade}" )
                                    ),
                                ],
                           ),
                        ),
                    ),
              );
        },
      ),
    );
  }
}
