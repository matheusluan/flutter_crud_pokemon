class PokemonModel {
  final int id;
  final String name;
  String image;
  final int order;
  final int height;
  final int weight;

  PokemonModel(
      {required this.id,
      required this.name,
      required this.order,
      required this.height,
      required this.weight,
      required this.image
    });

  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
    id: map['id'], 
    name: map['name'], 
    order: map['order'],
    height: map['height'], 
    weight: map['weight'],
    image: map['sprites']['front_default']
    );
  }
}
