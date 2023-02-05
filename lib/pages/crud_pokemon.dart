import 'package:flutter/material.dart';
import '../model/pokemon.dart';
import '../model/pokemon_db_helper.dart';

class PagePokemon extends StatefulWidget {
  const PagePokemon({super.key});

  @override
  State<PagePokemon> createState() => _PagePokemonState();
}

class _PagePokemonState extends State<PagePokemon> {
  Pokemon _pokemon = Pokemon();
  List<Pokemon> _pokemons = [];
  final PokemonDbHelper _pokemondbHelper = PokemonDbHelper();

  final _formKey = GlobalKey<FormState>();
  final _nomeEC = TextEditingController();
  final _tipoEC = TextEditingController();
  final _imagemEC = TextEditingController();
  final _habilidadeEC = TextEditingController();  

  late FocusNode _nomeFocusNode;

  @override
  void initState() {
    super.initState();
    _atualizarListaPokemons();
    _nomeFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nomeFocusNode.dispose();
    super.dispose();
  }

  _atualizarListaPokemons() async {
    List<Pokemon> c = await _pokemondbHelper.listarPokemons();
    setState(() {
      _pokemons = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Lista de pokemons',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),
            _listaPokemons(),
          ],
        ),
      ),
    );
  }

  _form() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _nomeEC,
            focusNode: _nomeFocusNode,
            decoration: const InputDecoration(labelText: 'Nome:'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
            onSaved: (value) => setState(() {
              _pokemon.nome = value!;
            }),
          ),
          TextFormField(
            controller: _tipoEC,
            decoration: const InputDecoration(labelText: 'Tipo:'),
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Campo obrigatório';
            //   }
            //   return null;
            // },
            onSaved: (value) => setState(() {
              _pokemon.tipo = value!;        
            }),
          ),
          TextFormField(
            controller: _imagemEC,
            decoration: const InputDecoration(labelText: 'Imagem:'),            
            onSaved: (value) => setState(() {
              _pokemon.imagem = value!;        
            }),
          ),
          TextFormField(
            controller: _habilidadeEC,
            decoration: const InputDecoration(labelText: 'Habilidade:'),            
            onSaved: (value) => setState(() {
              _pokemon.habilidade = value!;        
            }),
          ),
         
          ElevatedButton(
            onPressed: () {
              _onSubmit();
            },
            child: const Text('Salvar'),
          ),
        ]),
      ),
    );
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form?.validate() ?? false) {
      /*
      Quando chamo o save do form ele vai executar o onsaved de cada componente, 
      pegando o valor de cada campo e gravando no objeto
      */
      form!.save();
      if (_pokemon.id == null || _pokemon.id == 0) {
        await _pokemondbHelper.inserirPokemon(_pokemon);
      } else {
        await _pokemondbHelper.atualizarPokemon(_pokemon);
      }
      print('''
        Nome : ${_pokemon.nome}
        Tipo : ${_pokemon.tipo}
        Habilidade : ${_pokemon.habilidade}
        Imagem : ${_pokemon.imagem}
        ''');
      _resetForm();
      await _atualizarListaPokemons();
      _nomeFocusNode.requestFocus();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _nomeEC.clear();
      _tipoEC.clear();
      _habilidadeEC.clear();
      _imagemEC.clear();
      _pokemon.id = 0;
    });
  }

  _listaPokemons() {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.account_circle,
                      color: Colors.blueGrey,
                      size: 40.0,
                    ),
                    title: Text(
                      _pokemons[index].nome.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_pokemons[index].tipo),
                    onTap: () {
                      _exibirParaEdicao(index);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_sweep,
                          color: Colors.blueGrey),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Excluir o pokemon?'),
                              content: Text(_pokemons[index].nome),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _pokemondbHelper
                                        .excluirPokemon(_pokemons[index].id);
                                    _resetForm();
                                    _atualizarListaPokemons();
                                    Navigator.pop(context);
                                    _nomeFocusNode.requestFocus();
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(
                    height: 5.0,
                  ),
                ],
              );
            },
            itemCount: _pokemons.length,
          ),
        ),
      ),
    );
  }

  _exibirParaEdicao(index) {
    setState(() {
      _pokemon = _pokemons[index];
      _nomeEC.text = _pokemons[index].nome;
      _tipoEC.text = _pokemons[index].tipo;
      _imagemEC.text = _pokemons[index].imagem;
      _habilidadeEC.text = _pokemons[index].habilidade;
      
    });
  }
}
