import 'package:flutter/material.dart';
import 'package:flutter_crud_pokemon/pages/buscar_pokemon.dart';
import 'package:flutter_crud_pokemon/pages/crud_pokemon.dart';
import 'package:flutter_crud_pokemon/pages/gridview_pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pokedex'),
            centerTitle: true,
          ),
          body: Column(
            children: const [
              TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'Lista'),
                  Tab(text: 'Cadastro'),
                  Tab(text: 'Buscar Pokemon')                  
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GridViewPokemon(),
                    PagePokemon(),
                    BuscarPokemon()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
