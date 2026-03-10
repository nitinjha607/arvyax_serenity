import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/ambience.dart';
import '../../shared/widgets/breathing_gradient.dart';
import '../journal/reflection_screen.dart';
import 'player_providers.dart';

class SessionPlayerScreen extends ConsumerStatefulWidget {
  final Ambience ambience;

  const SessionPlayerScreen({super.key, required this.ambience});

  @override
  ConsumerState<SessionPlayerScreen> createState() => _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends ConsumerState<SessionPlayerScreen> {
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPlayer();
    });
  }

  Future<void> _initPlayer() async {
    final player = ref.read(audioPlayerProvider);
    ref.read(activeSessionProvider.notifier).setSession(widget.ambience);
    
    try {
      await player.setLoopMode(LoopMode.one);
      // Wait for setting the asset, which resolves the duration
      _duration = await player.setAsset(widget.ambience.audioAsset) ?? Duration.zero;
      
      _positionSubscription = player.positionStream.listen((pos) {
        if (!mounted) return;
        setState(() {
          _position = pos;
        });

        // If the position reaches the determined duration of one loop, end session
        if (_duration > Duration.zero && _position >= _duration) {
          _endSession();
        }
      });

      player.play();
    } catch (e) {
      debugPrint("Error loading audio: \$e");
    }
  }

  void _endSession() async {
    final player = ref.read(audioPlayerProvider);
    await player.stop();
    ref.read(activeSessionProvider.notifier).setSession(null);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ReflectionScreen(ambience: widget.ambience),
      ),
    );
  }

  void _confirmEndSession() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End Session Early?'),
        content: const Text('Are you sure you want to end your session now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _endSession();
            },
            child: const Text('End Session', style: TextStyle(color: Colors.red)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playerStateAsync = ref.watch(playerStateProvider);
    final isPlaying = playerStateAsync.value?.playing ?? false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.pop(context), // Pops down leaving active session
        ),
      ),
      body: BreathingBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Container(
                      color: theme.colorScheme.surface,
                      child: const Center(
                        child: Icon(Icons.spa, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  widget.ambience.title,
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.ambience.tag,
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position.inSeconds),
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      _formatDuration(_duration.inSeconds),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _duration.inSeconds > 0 ? _position.inSeconds / _duration.inSeconds : 0,
                  backgroundColor: theme.colorScheme.surface,
                  color: theme.colorScheme.onBackground,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.stop_circle_outlined, size: 48),
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      onPressed: _confirmEndSession,
                    ),
                    InkWell(
                      onTap: () {
                        final player = ref.read(audioPlayerProvider);
                        if (isPlaying) player.pause();
                        else player.play();
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: theme.colorScheme.background,
                          size: 40,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.library_music_outlined, size: 32),
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
