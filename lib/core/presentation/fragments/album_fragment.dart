import 'package:flutter/material.dart';

class AlbumFragment extends StatelessWidget {
  const AlbumFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Center(
        child: Text("l’édition du livre de séjour est disponible en version web"),
      ),
    );
  }
}
