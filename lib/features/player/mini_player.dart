import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'player_providers.dart';
import 'session_player_screen.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider);
    final isPlaying = ref.watch(playerStateProvider).value?.playing ?? false;
    final positionAsync = ref.watch(playerPositionProvider);
    final theme = Theme.of(context);
    
    if (activeSession == null) return const SizedBox.shrink();

    final currentPos = positionAsync.value?.inSeconds ?? 0;
    // For mini player, we might just query the underlying player instance or rely on the same duration approach.
    // If playerDurationProvider doesn't exist, we can use the ref.read(audioPlayerProvider).duration
    final audioPlayer = ref.read(audioPlayerProvider);
    final totalDur = audioPlayer.duration?.inSeconds ?? 0;
    final progress = totalDur > 0 ? (currentPos / totalDur).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SessionPlayerScreen(ambience: activeSession)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.onBackground.withOpacity(0.8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.background.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.spa, color: theme.colorScheme.background),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activeSession.title,
                    style: TextStyle(color: theme.colorScheme.background, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: theme.colorScheme.background.withOpacity(0.3),
                    color: theme.colorScheme.background,
                    minHeight: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: theme.colorScheme.background,
                size: 28,
              ),
              onPressed: () {
                final player = ref.read(audioPlayerProvider);
                if (isPlaying) player.pause();
                else player.play();
              },
            ),
          ],
        ),
            ),
          ),
        ),
      ),
    );
  }
}
