class Magasin {
  final String id;
  final String name;
  final String desc;
  final String url;
  final int note;

  const Magasin(this.id, this.name, this.desc, this.url, this.note);

  String get restname => this.name;
  String get restid => this.id;
}
