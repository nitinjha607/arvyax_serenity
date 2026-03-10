import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ambience.dart';
import '../../data/repositories/ambience_repository.dart';

final ambienceRepositoryProvider = Provider<AmbienceRepository>((ref) {
  return AmbienceRepository();
});

final ambiencesProvider = FutureProvider<List<Ambience>>((ref) {
  final repository = ref.read(ambienceRepositoryProvider);
  return repository.getAmbiences();
});

class SelectedTagNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void setTag(String? tag) => state = tag;
}

final selectedTagProvider = NotifierProvider<SelectedTagNotifier, String?>(SelectedTagNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String query) => state = query;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

final filteredAmbiencesProvider = Provider<List<Ambience>>((ref) {
  final ambiencesAsync = ref.watch(ambiencesProvider);
  final selectedTag = ref.watch(selectedTagProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return ambiencesAsync.maybeWhen(
    data: (ambiences) {
      return ambiences.where((ambience) {
        final matchesTag = selectedTag == null || ambience.tag == selectedTag;
        final matchesQuery = searchQuery.isEmpty || 
                             ambience.title.toLowerCase().contains(searchQuery) ||
                             ambience.description.toLowerCase().contains(searchQuery);
        return matchesTag && matchesQuery;
      }).toList();
    },
    orElse: () => [],
  );
});
