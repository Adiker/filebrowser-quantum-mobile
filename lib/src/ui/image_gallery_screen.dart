import '../api/safe_image_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../l10n/app_localizations.dart';
import '../api/filebrowser_client.dart';
import '../api/models.dart';
import 'file_details_sheet.dart';
import 'item_actions.dart';

/// Full-screen, swipeable, pinch-to-zoom photo viewer over the images in a
/// directory. Uses the server's large preview (a transcoded JPEG) so exotic
/// formats (HEIC/RAW/etc.) still display.
class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({
    super.key,
    required this.client,
    required this.images,
    required this.initialIndex,
    this.actions,
    this.onChanged,
  });

  final FileBrowserClient client;
  final List<FbResource> images;
  final int initialIndex;

  /// The shared per-item flows; when present the app bar carries the full
  /// [ItemActionsMenu] for the image currently shown.
  final ItemActions? actions;

  /// Invoked after a rename/delete here changed the server, so the screen
  /// beneath (the browser) can refresh its listing.
  final VoidCallback? onChanged;

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  late final PageController _pageController;
  late int _index;

  // Own mutable copy of the pages: a deleted image is dropped from the gallery
  // in place (like the OS gallery) rather than closing the whole viewer.
  late final List<FbResource> _images = [...widget.images];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// The shown image was renamed: its path (and preview URL) changed, so
  /// notify the browser and close rather than display a stale page. Invoked
  /// after an async flow, hence the mounted guards here and in
  /// [_handleDeleted].
  void _handleRenamed() {
    widget.onChanged?.call();
    if (mounted) Navigator.of(context).pop();
  }

  /// The shown image was deleted: drop its page and stay on the neighbour,
  /// closing only when it was the last one.
  void _handleDeleted() {
    widget.onChanged?.call();
    if (!mounted) return;
    if (_images.length <= 1) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _images.removeAt(_index);
      if (_index >= _images.length) _index = _images.length - 1;
    });
    _pageController.jumpToPage(_index);
  }

  @override
  Widget build(BuildContext context) {
    final current = _images[_index];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)
              .galleryTitle(_index + 1, _images.length, current.name),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: AppLocalizations.of(context).actionDetails,
            onPressed: () => FileDetailsSheet.show(
              context,
              resource: current,
              client: widget.client,
            ),
          ),
          if (widget.actions != null)
            ItemActionsMenu(
              actions: widget.actions!,
              resource: current,
              onRenamed: _handleRenamed,
              onDeleted: _handleDeleted,
            ),
        ],
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: _images.length,
        onPageChanged: (i) => setState(() => _index = i),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
        builder: (context, i) {
          final item = _images[i];
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              cacheManager: safeImageCache,
              widget.client.previewUri(item.path, size: 'large').toString(),
              headers: widget.client.authHeaders,
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4,
            heroAttributes: PhotoViewHeroAttributes(tag: item.path),
          );
        },
      ),
    );
  }
}
