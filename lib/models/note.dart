import 'package:isar/isar.dart';

// this line need togenerate file
//then run:  dart run build_runner build

part 'note.g.dart';


@Collection()
class Note {
   late Id id = Isar.autoIncrement;
   late String text;
}