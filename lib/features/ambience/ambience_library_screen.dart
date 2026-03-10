import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ambience_providers.dart';
import 'ambience_details_screen.dart';
import '../journal/journal_history_screen.dart';
import '../player/mini_player.dart';
import '../../shared/theme/colors.dart';

class AmbienceLibraryScreen extends ConsumerWidget {
  const AmbienceLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAmbiences = ref.watch(filteredAmbiencesProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history_edu, color: theme.colorScheme.onSurface),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JournalHistoryScreen()),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Library',
                          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search ambiences...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) =>
                          ref.read(searchQueryProvider.notifier).setQuery(value),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(context, ref, 'Focus', AppColors.tagFocus, AppColors.tagFocusText, selectedTag),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, ref, 'Calm', AppColors.tagCalm, AppColors.tagCalmText, selectedTag),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, ref, 'Sleep', AppColors.tagSleep, AppColors.tagSleepText, selectedTag),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, ref, 'Reset', AppColors.tagReset, AppColors.tagResetText, selectedTag),
                          if (selectedTag != null) ...[
                            const SizedBox(width: 8),
                            ActionChip(
                              label: const Icon(Icons.close, size: 16),
                              onPressed: () => ref.read(selectedTagProvider.notifier).setTag(null),
                              backgroundColor: theme.colorScheme.surface,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (filteredAmbiences.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No ambiences found',
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final ambience = filteredAmbiences[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AmbienceDetailsScreen(ambience: ambience),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 8,
                          shadowColor: theme.shadowColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                    color: theme.colorScheme.primary.withOpacity(0.1),
                                    image: DecorationImage(
                                      image: NetworkImage(ambience.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ambience.title,
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredAmbiences.length,
                  ),
                ),
              ),
          ],
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, WidgetRef ref, String tag, Color bgColor, Color textColor, String? selectedTag) {
    final isSelected = tag == selectedTag;
    return ChoiceChip(
      label: Text(tag, style: TextStyle(color: isSelected ? Colors.white : textColor, fontWeight: FontWeight.bold)),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(selectedTagProvider.notifier).setTag(selected ? tag : null);
      },
      selectedColor: textColor,
      backgroundColor: bgColor,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
