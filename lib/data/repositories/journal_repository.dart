import 'package:hive/hive.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  static const String boxName = 'journalBox';

  Future<Box<JournalEntry>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<JournalEntry>(boxName);
    }
    return Hive.box<JournalEntry>(boxName);
  }

  Future<void> saveEntry(JournalEntry entry) async {
    final box = await _getBox();
    await box.put(entry.id, entry);
  }

  Future<List<JournalEntry>> getEntries() async {
    final box = await _getBox();
    final entries = box.values.toList();
    entries.sort((a, b) => b.date.compareTo(a.date)); // descending
    return entries;
  }
}
