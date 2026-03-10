import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_audio/just_audio.dart';
import '../../data/models/ambience.dart';

// Provides a singleton AudioPlayer instance
final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

// Provides the current active ambience session
class ActiveSessionNotifier extends Notifier<Ambience?> {
  @override
  Ambience? build() => null;
  void setSession(Ambience? ambience) => state = ambience;
}

final activeSessionProvider = NotifierProvider<ActiveSessionNotifier, Ambience?>(ActiveSessionNotifier.new);

// Streams the player position
final playerPositionProvider = StreamProvider<Duration>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.positionStream;
});

// Streams the player state (playing, paused, completed)
final playerStateProvider = StreamProvider<PlayerState>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.playerStateStream;
});
