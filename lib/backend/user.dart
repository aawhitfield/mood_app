import 'package:mood_app/backend/entry.dart';

class User{
int id;
String name;
String avatar;
List<Entry> journal;

User(this.id, this.name, this.avatar, this.journal);

}