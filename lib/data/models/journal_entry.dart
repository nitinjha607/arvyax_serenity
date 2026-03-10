import 'package:hive/hive.dart';

class JournalEntry {
  final String id;
  final DateTime date;
  final String ambienceId;
  final String ambienceTitle;
  final String mood;
  final String text;

  JournalEntry({
    required this.id,
    required this.date,
    required this.ambienceId,
    required this.ambienceTitle,
    required this.mood,
    required this.text,
  });
}

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      ambienceId: fields[2] as String,
      ambienceTitle: fields[3] as String,
      mood: fields[4] as String,
      text: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.ambienceId)
      ..writeByte(3)
      ..write(obj.ambienceTitle)
      ..writeByte(4)
      ..write(obj.mood)
      ..writeByte(5)
      ..write(obj.text);
  }
}
