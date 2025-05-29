import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:b3_dev/main.dart';
import 'package:b3_dev/models/character.dart';
import 'package:b3_dev/models/message.dart';
import 'package:b3_dev/utils/constants.dart' as config;

class ChatScreen extends StatefulWidget {
  final Character character;

  const ChatScreen({super.key, required this.character});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  int? _conversationId;
  bool _isFirstConversation = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      // Essayer de récupérer les conversations existantes
      final url = Uri.parse('${config.Constants.apiBaseUrl}/characters/${widget.character.id}/conversations');
      print('Chargement des conversations depuis: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Statut de la réponse (conversations): ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print('Conversations trouvées: ${jsonData.length}');

        // S'il y a des conversations existantes
        if (jsonData.isNotEmpty) {
          // Récupérer la dernière conversation
          final latestConversation = jsonData.last;
          _conversationId = latestConversation['id'];
          print('Conversation ID trouvée: $_conversationId');

          // Charger les messages de cette conversation
          await _loadConversationMessages(_conversationId!);
        } else {
          // Pas de conversation, indiquer qu'il faut commencer
          setState(() {
            _isFirstConversation = true;
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 404) {
        // API ne trouve pas de conversations, c'est la première fois
        setState(() {
          _isFirstConversation = true;
          _isLoading = false;
        });
      } else {
        throw Exception('Échec de chargement des conversations (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.showSnackBar('Erreur: ${e.toString()}', isError: true);
        print('Exception complète: $e');
      }
    }
  }

  Future<void> _createNewConversation() async {
    try {
      setState(() {
        _isSending = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final url = Uri.parse('${config.Constants.apiBaseUrl}/characters/${widget.character.id}/conversations');
      print('Création d\'une nouvelle conversation: $url');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          // Si l'API a besoin de données pour créer une conversation, ajoutez-les ici
        }),
      );

      print('Statut de la réponse (création): ${response.statusCode}');
      print('Réponse (création): ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _conversationId = jsonData['id'];

        setState(() {
          _isFirstConversation = false;
          _isSending = false;
        });

        return; // Conversation créée avec succès
      } else {
        throw Exception('Échec de création de conversation (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      context.showSnackBar('Erreur: ${e.toString()}', isError: true);
      print('Exception complète: $e');
    }
  }

  Future<void> _loadConversationMessages(int conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      final url = Uri.parse('${config.Constants.apiBaseUrl}/conversations/$conversationId/messages');
      print('Chargement des messages depuis: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Statut de la réponse (messages): ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Message> fetchedMessages = [];

        for (var json in jsonList) {
          try {
            final message = Message.fromJson(json);
            fetchedMessages.add(message);
          } catch (e) {
            print('Erreur lors du parsing du message: $e');
          }
        }

        if (mounted) {
          setState(() {
            _messages = fetchedMessages;
            _isLoading = false;
          });

          // Scroll vers le bas une fois que les messages sont chargés
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }
      } else {
        throw Exception('Échec de chargement des messages (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.showSnackBar('Erreur de chargement: ${e.toString()}', isError: true);
        print('Exception complète: $e');
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Créer une nouvelle conversation si c'est la première fois
    if (_isFirstConversation || _conversationId == null) {
      await _createNewConversation();
      if (_conversationId == null) {
        // Si la création a échoué, arrêter ici
        return;
      }
    }

    setState(() {
      _isSending = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token non trouvé');
      }

      _messageController.clear();

      // Ajouter le message de l'utilisateur localement pour l'affichage immédiat
      final userMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        isUser: true,
        conversationId: _conversationId,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(userMessage);
      });

      // Scroll vers le bas après l'ajout du message
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      // Envoyer le message au serveur
      final url = Uri.parse('${config.Constants.apiBaseUrl}/conversations/$_conversationId/messages');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': text,
          'is_sent_by_human': true,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Charger tous les messages pour obtenir également la réponse du personnage
        await _loadConversationMessages(_conversationId!);
      } else {
        throw Exception('Échec d\'envoi du message (${response.statusCode})');
      }
    } catch (e) {
      context.showSnackBar('Erreur d\'envoi: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec ${widget.character.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_conversationId != null) {
                _loadConversationMessages(_conversationId!);
              } else {
                _loadMessages();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: _isFirstConversation && _messages.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Commencez à discuter avec ${widget.character.name}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Envoyez votre premier message pour débuter la conversation',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          if (_isSending)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LinearProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Écrivez un message...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: message.isUser ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: message.isUser
                    ? Colors.white.withOpacity(0.7)
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
