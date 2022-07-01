import 'package:flutter/material.dart';
import 'package:aldjazair/magasin/magasin.dart';

class FavoriteIcon extends StatefulWidget {
  final Function fun;

  const FavoriteIcon({Key key, this.fun}) : super(key: key);
  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool _isFavorite = false;
  List<Magasin> favorites = [];
  Magasin magasin;

  void changeColor() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _handleFavoritesListChanged(Magasin r) {
    setState(() {
      if (favorites.contains(r)) {
        favorites.remove(r);
        setState(() {});
      } else {
        favorites.add(r);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeColor();

        _handleFavoritesListChanged(magasin);

        widget.fun(_isFavorite);
        // Favorite();
      },
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.black,
      ),
    );
  }
}
