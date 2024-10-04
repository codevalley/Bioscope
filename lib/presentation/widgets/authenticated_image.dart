import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/providers.dart';

final authenticatedUrlProvider =
    FutureProvider.family<String, String>((ref, imagePath) async {
  final repository = ref.watch(foodEntryRepositoryProvider);
  return repository.getAuthenticatedImageUrl(imagePath);
});

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
    final authenticatedUrlAsync =
        ref.watch(authenticatedUrlProvider(imagePath));

    return authenticatedUrlAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Icon(Icons.error),
      data: (authenticatedUrl) {
        return CachedNetworkImage(
          imageUrl: authenticatedUrl,
          cacheKey: imagePath, // Use imagePath (file name) as cache key
          fit: fit,
          maxHeightDiskCache: 1000,
          maxWidthDiskCache: 1000,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
    );
  }
}
