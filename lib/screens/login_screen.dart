import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),

        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Titre de la page
            Text(
              'Bienvenue !\nVeuillez vous connecter',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,

                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40), // Espacement entre le titre et les champs

            // Champ de texte pour l'email
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Entrez votre email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 16), // Espacement entre les champs

            // Champ de texte pour le mot de passe
            TextField(
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                hintText: 'Entrez votre mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 32), // Espacement entre les champs et le bouton

            // Bouton de connexion
            ElevatedButton(
              onPressed: () {
                // Logique de connexion
                print('Connexion');
              },
              child: const Text(
                'Se connecter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Couleur du bouton
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Bordure arrondie
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 16), // Espacement sous le bouton

            // Lien pour s'inscrire
            TextButton(
              onPressed: () {
                // Logique pour rediriger vers la page d'inscription
                print('S\'inscrire');
              },
              child: const Text(
                'Pas de compte ? Créez-en un.',
                style: TextStyle(
                  color: Colors.blueAccent, // Couleur du texte du lien
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
