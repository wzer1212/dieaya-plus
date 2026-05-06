import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DeepLinkService extends GetxService {
  late final AppLinks _appLinks;

  Future<DeepLinkService> init() async {
    _appLinks = AppLinks();

    // Listen for deep links when the app is in the foreground or background
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        _handleUri(uri); // navigate accordingly
      }
    });

    // Handle when the app is cold-started by a deep link
    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      _handleUri(initial);  // Navigate accordingly
    }

    return this;
  }

  void _handleUri(Uri uri) {
    final segs = uri.pathSegments;
    if (segs.isEmpty) return;

    switch (segs.first) {
      case 'product':
        final id = segs.length > 1 ? segs[1] : null;
        if (id != null) {
          Get.toNamed('/product/$id');
        }
        break;
      case 'market':
      // handle market path similarly
        break;
      default:
        break;
    }
  }
}
