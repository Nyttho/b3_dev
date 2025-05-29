import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:b3_dev/models/universe.dart';
import 'package:b3_dev/screens/auth/login_screen.dart';
import 'package:b3_dev/screens/universe/character_list_screen.dart';
import 'package:b3_dev/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:b3_dev/utils/constants.dart' as config;

class UniverseListScreen extends StatefulWidget {
  const UniverseListScreen({super.key});

  @override
  State<UniverseListScreen> createState() => _UniverseListScreenState();
}

class _UniverseListScreenState extends State<UniverseListScreen> {
  List<Universe> _universes = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadUniverses();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('token');
    });
  }

  Future<void> _loadUniverses() async {
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

      final url = Uri.parse('${config.Constants.apiBaseUrl}/universes');
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
          _universes = jsonList.map((json) => Universe.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Erreur lors de la récupération des univers (${response.statusCode})');
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

  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fictional Universes'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUniverses,
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
                onPressed: _loadUniverses,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    } else if (_universes.isEmpty) {
      return const Center(
        child: Text('Aucun univers trouvé.'),
      );
    } else {
      return ListView.builder(
        itemCount: _universes.length,
        itemBuilder: (context, index) => _buildUniverseCard(context, _universes[index]),
      );
    }
  }

  Widget _buildUniverseCard(BuildContext context, Universe universe) {
    String imageUrl = '';

    // Construction de l'URL d'image avec vérification
    if (universe.image != null && universe.image!.isNotEmpty) {
      imageUrl = "${config.Constants.apiBaseUrl}/image_data/${universe.image}";
      print("Image URL: $imageUrl"); // Pour debug
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image avec authentification
          Container(
            height: 180,
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
                print('Erreur image: $error');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      Text(
                        universe.name,
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
              child: Text(
                universe.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  universe.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _buildExpandableDescription(context, universe.description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${universe.characterCount} personnages',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CharacterListScreen(universe: universe),
                            ),
                          );
                        },
                        icon: const Icon(Icons.people),
                        label: Text(
                          universe.characterCount > 0
                              ? 'Voir les ${universe.characterCount} personnages'
                              : 'Explorer les personnages',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableDescription(BuildContext context, String? description) {
    final desc = description ?? '';

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
        'Voir plus...',
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

  // Formater une date pour l'affichage
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
