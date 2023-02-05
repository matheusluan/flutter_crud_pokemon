import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_pokemon/model/pokemonAPI.dart';
import 'package:flutter_crud_pokemon/repositories/pokemon_repository.dart';
import 'package:flutter_crud_pokemon/repositories/pokemon_repository_impl.dart';

class BuscarPokemon extends StatefulWidget {
  const BuscarPokemon({super.key});

  @override
  State<BuscarPokemon> createState() => _PageBuscarPokemonState();
}

class _PageBuscarPokemonState extends State<BuscarPokemon> {
  PokemonRepository pokemonRepository = PokemonRepositoryImpl();
  bool loading = false;

  //Coloquei só pra renderizar o card
  PokemonModel pokemonNN = PokemonModel(
      id: 0,
      name: "",
      order: 0,
      height: 0,
      weight: 0,
      image: "https://pokeapi.co/static/pokeapi_256.3fa72200.png");

  //para recuperar um dado editado, preciso
  //de um TextEditingController
  final pokemonEC = TextEditingController();

  //para fazer validação preciso adicionar uma chave no meu formulário
  //assim consigo acessar o estado do form (existe um método chamado validade)
  final formkey = GlobalKey<FormState>();

  //descarta os TextEditingController após o uso
  @override
  void dispose() {
    pokemonEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Pokemon API'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                controller: pokemonEC,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pokemon obrigatório';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final valido = formkey.currentState?.validate() ?? false;
                  if (valido) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final poke = await pokemonRepository
                          .getPokemon(pokemonEC.text.toLowerCase());
                      setState(() {
                        pokemonNN = poke;
                        loading = false;
                      });
                    } on Exception catch (e) {
                      setState(() {
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Erro ao buscar pokemon')));
                    }
                  }
                },
                child: const Text('Buscar Pokemon'),
              ),
              Visibility(
                visible: loading,
                child: const CircularProgressIndicator(),
              ),
              Visibility(child: _cardPokemon())
            ],
          ),
        ),
      ),
    );
  }

  _cardPokemon() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: InkWell(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(pokemonNN.image,
                    width: 180, height: 180, fit: BoxFit.fill),
              ),
              ListTile(
                  title:
                      Center(child: Text("${pokemonNN.name.toUpperCase()}\n")),
                  subtitle: Text(
                      "ID: ${pokemonNN.id != 0 ? pokemonNN.id : ''}\nPeso:${pokemonNN.weight != 0 ? pokemonNN.weight : ''}\nAltura:${pokemonNN.height != 0 ? pokemonNN.height : ''}\nOrdem:${pokemonNN.order != 0 ? pokemonNN.order : ''}")),
              _copiarUrl()
            ],
          ),
        ),
      ),
    );
  }

  _copiarUrl() {
    return TextButton(
      onPressed: () async {
        FlutterClipboard.copy(pokemonNN.image).then(
          (value) {
            return ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Imagem Copiada'),
              ),
            );
          },
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      child: const Text(
        'Copiar url da imagem',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
