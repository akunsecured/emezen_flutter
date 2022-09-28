import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppBar().preferredSize.height,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            suffixIcon: Container(
              height: AppBar().preferredSize.height,
              decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            )),
      ),
    );
  }
}
