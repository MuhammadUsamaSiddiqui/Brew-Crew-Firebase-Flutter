import 'package:brew_crew/models/brew.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brew_tile.dart';

class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<Brew>>(context);

    if (brews != null) {
      brews.forEach((brew) {
        print(brew.name);
        print(brew.strength);
        print(brew.sugars);
      });
    }
    return ListView.builder(
        itemCount: brews == null ? 0 : brews.length,
        itemBuilder: (BuildContext context, int position) {
          return BrewTile(brew: brews[position]);
        });
  }
}
