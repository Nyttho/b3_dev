// screens/universe/character_list_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:b3_dev/models/universe.dart';
import 'package:b3_dev/models/character.dart';
import 'package:b3_dev/screens/chat/chat_screen.dart';
import 'package:b3_dev/utils/constants.dart' as config;

class CharacterListScreen extends StatefulWidget {
  final Universe universe;

  const CharacterListScreen({Key? key, required this.universe}) : super(key: key);

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  List<Character> _characters = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadCharacters();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('token');
    });
  }

  Future<void> _loadCharacters() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé.');
      }

      _authToken = token; // Stocke le token pour l'utiliser avec les images

      final url = Uri.parse('${config.Constants.apiBaseUrl}/universes/${widget.universe.id}/characters');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        setState(() {
          _characters = jsonList.map((json) => Character.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Erreur lors de la récupération des personnages (${response.statusCode})');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personnages de ${widget.universe.name}'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadCharacters,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Erreur: $_errorMessage',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadCharacters,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    } else if (_characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Aucun personnage trouvé dans cet univers.',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _characters.length,
        itemBuilder: (context, index) {
          return _buildCharacterCard(_characters[index]);
        },
      );
    }
  }

  Widget _buildCharacterCard(Character character) {
    String imageUrl = '';
    if (character.image != null && character.image!.isNotEmpty) {
      imageUrl = '${config.Constants.apiBaseUrl}/image_data/${character.image}';
      print("Character Image URL: $imageUrl"); // Pour debug
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(character: character),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                headers: _authToken != null
                    ? {'Authorization': 'Bearer $_authToken'}
                    : null,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Erreur image character: $error');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 50, color: Colors.grey),
                        Text(
                          character.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_outline, size: 50, color: Colors.grey),
                    Text(
                      character.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildExpandableDescription(context, character.description),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(character: character),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Discuter'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableDescription(BuildContext context, String? description) {
    final desc = description ?? '';

    // Si pas de description ou description très courte
    if (desc.isEmpty) {
      return Text(
        'Aucune description disponible.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      );
    }

    // Si la description est courte, l'afficher directement
    if (desc.length < 150) {
      return Text(
        desc,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    // Sinon, utiliser un widget qui permet de développer le texte
    return ExpansionTile(
      title: Text(
        'Voir la description complète',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      tilePadding: EdgeInsets.zero,
      children: [
        Text(
          desc,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
      subtitle: Text(
        desc.substring(0, 150) + '...',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
