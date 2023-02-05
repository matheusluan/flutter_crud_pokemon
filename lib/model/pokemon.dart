

class Pokemon {
  int id;
  String nome;
  String tipo;
  String habilidade;
  String imagem;

  Pokemon({
    this.id = 0,
    this.nome = '',
    this.tipo = '',
    this.habilidade = '',
    this.imagem = '' 
  });

  static const tablePokemon = 'tb_pokemon';
  static const colId = 'id';
  static const colNome = 'nome';
  static const colTipo = 'tipo';
  static const colHabilidade = 'habilidade';
  static const colImagem = 'imagem';

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map[colId],
      nome: map[colNome],
      tipo: map[colTipo],
      habilidade: map[colHabilidade],
      imagem: map[colImagem]
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colNome: nome,
      colTipo: tipo,
      colHabilidade: habilidade,
      colImagem: imagem
    };
    if (map[colId] != null) {
      map[colId] = id;
    }
    return map;
  }
}
