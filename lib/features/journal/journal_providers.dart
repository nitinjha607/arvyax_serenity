import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/journal_entry.dart';
import '../../data/repositories/journal_repository.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final repository = ref.read(journalRepositoryProvider);
  return repository.getEntries();
});
