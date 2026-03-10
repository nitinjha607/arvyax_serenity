import 'package:flutter/material.dart';
import '../../data/models/ambience.dart';
import '../../shared/theme/colors.dart';
import '../player/session_player_screen.dart';

class AmbienceDetailsScreen extends StatelessWidget {
  final Ambience ambience;

  const AmbienceDetailsScreen({super.key, required this.ambience});

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Focus': return AppColors.tagFocus;
      case 'Calm': return AppColors.tagCalm;
      case 'Sleep': return AppColors.tagSleep;
      case 'Reset': return AppColors.tagReset;
      default: return AppColors.lightSurface;
    }
  }

  Color _getTagTextColor(String tag) {
    switch (tag) {
      case 'Focus': return AppColors.tagFocusText;
      case 'Calm': return AppColors.tagCalmText;
      case 'Sleep': return AppColors.tagSleepText;
      case 'Reset': return AppColors.tagResetText;
      default: return AppColors.lightOnSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Image Placeholder
            Hero(
              tag: ambience.id,
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  image: DecorationImage(
                    image: NetworkImage(ambience.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ambience.title,
                          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getTagColor(ambience.tag),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          ambience.tag,
                          style: TextStyle(color: _getTagTextColor(ambience.tag), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sensory Recipe',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ambience.sensoryChips.map((chip) {
                      return Chip(
                        label: Text(chip),
                        backgroundColor: theme.colorScheme.surface,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ambience.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 100), // spacing for FAB
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SessionPlayerScreen(ambience: ambience),
                ),
              );
            },
            backgroundColor: theme.colorScheme.onBackground,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            label: Text(
              'Start Session',
              style: TextStyle(color: theme.colorScheme.background, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
