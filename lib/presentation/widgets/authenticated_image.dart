import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            fit: fit,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        } else {
          return const Icon(Icons.image_not_supported);
        }
      },
    );
  }
}
