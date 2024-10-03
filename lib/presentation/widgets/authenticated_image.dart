// In a new file, e.g., authenticated_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class AuthenticatedImage extends ConsumerWidget {
  final String imagePath;
  final BoxFit fit;

  const AuthenticatedImage({
    Key? key,
    required this.imagePath,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      future: ref
          .read(foodEntryRepositoryProvider)
          .getAuthenticatedImageUrl(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else if (snapshot.hasData) {
          return Image.network(
            snapshot.data!,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image);
            },
          );
        } else {
          return const Icon(Icons.image_not_supported);
        }
      },
    );
  }
}
