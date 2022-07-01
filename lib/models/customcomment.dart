class CustomComment {
  String nom;
  String prenom;
  String commentid;
  String _message;
  bool _liked;
  String lienImage;
  bool _dislike;
  int nbrlike;
  int nbrdislike;
  CustomComment(this.nom,this.prenom,this._message,this._liked,this._dislike,this.commentid,this.nbrlike,this.nbrdislike,this.lienImage);

  String getmessage () => _message;
  bool getliked () => _liked;
  bool getdislike () => _dislike;

  void setLiked(bool b){
    _liked=b;
  }

  void setDisliked(bool b){
    _dislike=b;
  }
} 