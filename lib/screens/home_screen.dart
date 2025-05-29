import 'package:flutter/material.dart';

// Liste des univers
final List<String> universList = [
  'Univers 1',
  'Univers 2',
  'Univers 3',
  'Univers 4',
  'Univers 5',
];

// Custom AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Liste des Univers'),

      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {

          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Définit la hauteur de l'AppBar
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Utilisation de la Custom AppBar
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sélectionnez un univers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          // Liste des univers
          Expanded(
            child: ListView.builder(
              itemCount: universList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4.0,
                    child: Row(
                      children: [
                        // Image de l'univers
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/star_wars.jpg',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Titre de l'univers
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              universList[index],
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
