

class Monument {
  double latitude;
  double longitude;
  String titre;
  int distance;
  String shortdescription;
  int note;
  String categorie;
  String periode;
  String type;

  Monument(this.latitude, this.longitude,this.titre,this.type,{this.distance,this.note,this.categorie,this.periode,this.shortdescription,});
  void setNote(int note){
    this.note=note;
}
  /*Future<double> distance() async {
    var location = new Location();
    LocationData userlocation = await location.getLocation();
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((latitude - userlocation.latitude) * p) / 2 +
        c(userlocation.latitude * p) *
            c(latitude * p) *
            (1 - c((longitude - userlocation.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }*/
}
