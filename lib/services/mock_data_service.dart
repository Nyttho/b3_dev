import 'package:b3_dev/models/universe.dart';
import 'package:b3_dev/models/character.dart';
import 'package:b3_dev/models/message.dart';

class MockDataService {
  // Mock universes data
  List<Universe> getUniverses() {
    return [
      Universe(
        id: '1',
        name: 'Star Wars',
        description: 'A long time ago in a galaxy far, far away...',
        imageUrl: 'https://picsum.photos/seed/starwars/300/200',
        characterCount: 5,
      ),
      Universe(
        id: '2',
        name: 'Marvel',
        description: 'Home to superheroes and villains with extraordinary abilities',
        imageUrl: 'https://picsum.photos/seed/marvel/300/200',
        characterCount: 4,
      ),
      Universe(
        id: '3',
        name: 'Harry Potter',
        description: 'The wizarding world of magic and adventure',
        imageUrl: 'https://picsum.photos/seed/harrypotter/300/200',
        characterCount: 3,
      ),
      Universe(
        id: '4',
        name: 'Lord of the Rings',
        description: 'Epic fantasy adventure in Middle-earth',
        imageUrl: 'https://picsum.photos/seed/lotr/300/200',
        characterCount: 4,
      ),
    ];
  }

  // Mock characters data
  List<Character> getCharactersByUniverse(String universeId) {
    switch (universeId) {
      case '1': // Star Wars
        return [
          Character(
            id: '101',
            universeId: '1',
            name: 'Luke Skywalker',
            description: 'Jedi Knight and hero of the Rebellion',
            imageUrl: 'https://picsum.photos/seed/luke/200/200',
          ),
          Character(
            id: '102',
            universeId: '1',
            name: 'Darth Vader',
            description: 'Dark Lord of the Sith',
            imageUrl: 'https://picsum.photos/seed/vader/200/200',
          ),
          Character(
            id: '103',
            universeId: '1',
            name: 'Princess Leia',
            description: 'Leader of the Rebellion',
            imageUrl: 'https://picsum.photos/seed/leia/200/200',
          ),
          Character(
            id: '104',
            universeId: '1',
            name: 'Han Solo',
            description: 'Smuggler and captain of the Millennium Falcon',
            imageUrl: 'https://picsum.photos/seed/han/200/200',
          ),
          Character(
            id: '105',
            universeId: '1',
            name: 'Yoda',
            description: 'Jedi Master',
            imageUrl: 'https://picsum.photos/seed/yoda/200/200',
          ),
        ];
      case '2': // Marvel
        return [
          Character(
            id: '201',
            universeId: '2',
            name: 'Iron Man',
            description: 'Genius billionaire playboy philanthropist',
            imageUrl: 'https://picsum.photos/seed/ironman/200/200',
          ),
          Character(
            id: '202',
            universeId: '2',
            name: 'Captain America',
            description: 'Super-soldier and leader of the Avengers',
            imageUrl: 'https://picsum.photos/seed/cap/200/200',
          ),
          Character(
            id: '203',
            universeId: '2',
            name: 'Thor',
            description: 'God of Thunder',
            imageUrl: 'https://picsum.photos/seed/thor/200/200',
          ),
          Character(
            id: '204',
            universeId: '2',
            name: 'Black Widow',
            description: 'Master spy and assassin',
            imageUrl: 'https://picsum.photos/seed/widow/200/200',
          ),
        ];
      case '3': // Harry Potter
        return [
          Character(
            id: '301',
            universeId: '3',
            name: 'Harry Potter',
            description: 'The Boy Who Lived',
            imageUrl: 'https://picsum.photos/seed/harry/200/200',
          ),
          Character(
            id: '302',
            universeId: '3',
            name: 'Hermione Granger',
            description: 'Brightest witch of her age',
            imageUrl: 'https://picsum.photos/seed/hermione/200/200',
          ),
          Character(
            id: '303',
            universeId: '3',
            name: 'Ron Weasley',
            description: 'Harry\'s loyal friend',
            imageUrl: 'https://picsum.photos/seed/ron/200/200',
          ),
        ];
      case '4': // Lord of the Rings
        return [
          Character(
            id: '401',
            universeId: '4',
            name: 'Frodo Baggins',
            description: 'Ring-bearer and hobbit of the Shire',
            imageUrl: 'https://picsum.photos/seed/frodo/200/200',
          ),
          Character(
            id: '402',
            universeId: '4',
            name: 'Gandalf',
            description: 'Wizard and member of the Istari',
            imageUrl: 'https://picsum.photos/seed/gandalf/200/200',
          ),
          Character(
            id: '403',
            universeId: '4',
            name: 'Aragorn',
            description: 'Heir to the throne of Gondor',
            imageUrl: 'https://picsum.photos/seed/aragorn/200/200',
          ),
          Character(
            id: '404',
            universeId: '4',
            name: 'Legolas',
            description: 'Elven prince of the Woodland Realm',
            imageUrl: 'https://picsum.photos/seed/legolas/200/200',
          ),
        ];
      default:
        return [];
    }
  }

  // Mock messages for chat
  List<Message> getInitialMessages(String characterId) {
    final now = DateTime.now();

    return [
      Message(
        id: '1',
        senderId: characterId,
        content: 'Hello there! How can I help you today?',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isUser: false,
      ),
    ];
  }

  // Mock response from character (simulating AI response)
  Future<Message> getCharacterResponse(String characterId, String userMessage) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    String response = '';

    // Simple response based on character
    switch (characterId) {
      case '101': // Luke
        response = 'The Force will be with you. Always.';
        break;
      case '102': // Vader
        response = 'I find your lack of faith disturbing.';
        break;
      case '201': // Iron Man
        response = 'Sometimes you gotta run before you can walk.';
        break;
      case '301': // Harry
        response = 'I solemnly swear that I am up to no good.';
        break;
      case '401': // Frodo
        response = 'I will take the Ring, though I do not know the way.';
        break;
      default:
        response = 'It\'s nice to chat with you!';
    }

    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: characterId,
      content: response,
      timestamp: now,
      isUser: false,
    );
  }
}

