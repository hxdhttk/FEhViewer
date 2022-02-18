import 'package:fehviewer/common/service/controller_tag_service.dart';
import 'package:fehviewer/models/base/eh_models.dart';
import 'package:fehviewer/network/api.dart';
import 'package:fehviewer/network/request.dart';
import 'package:fehviewer/utils/logger.dart';
import 'package:get/get.dart';

import 'gallery_page_controller.dart';

class TorrentController extends GetxController
    with StateMixin<TorrentProvider> {
  TorrentController();

  GalleryPageController get pageController => Get.find(tag: pageCtrlTag);
  late String torrentTk;
  bool isRefresh = false;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<TorrentProvider> _fetch() async {
    final _torrentLink = '${Api.getBaseUrl()}/gallerytorrents.php'
        '?gid=${pageController.gid}&t=${pageController.galleryItem?.token}';
    logger.d(_torrentLink);
    return await getTorrent(_torrentLink);
  }

  Future<void> _loadData() async {
    try {
      final TorrentProvider provider = await _fetch();
      change(provider, status: RxStatus.success());
    } catch (e, stack) {
      logger.e('$e\n$stack');
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> reload() async {
    change(state, status: RxStatus.loading());
    await _loadData();
  }

  Future<String> _fetchTk() async {
    return await getTorrentToken(
        pageController.gid, pageController.galleryItem?.token ?? '',
        refresh: isRefresh);
  }
}

class TorrentProvider {
  late List<GalleryTorrent> torrents;
  late String torrentToken;
}
