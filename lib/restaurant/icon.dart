import 'package:flutter/material.dart';
import 'package:aldjazair/restaurant/restaurant.dart';

class FavoriteIcon extends StatefulWidget {
  final Function fun;

  const FavoriteIcon({Key key, this.fun}) : super(key: key);
  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool _isFavorite = false;
  List<Restaurant> favorites = [];
  Restaurant restaurents;

  void changeColor() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _handleFavoritesListChanged(Restaurant r) {
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

        _handleFavoritesListChanged(restaurents);

        widget.fun(_isFavorite);
      },
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.black,
      ),
    );
  }
}
