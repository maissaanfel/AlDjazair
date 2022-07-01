class Restaurant {
  final String id;
  final String name;
  final String stitr;
  final String url;
  final String desc;
  final int note;

  const Restaurant(
      this.id, this.name, this.stitr, this.url, this.desc, this.note);

  String get restname => this.name;
  String get restid => this.id;
}
