import 'package:FEhViewer/models/entity/favorite.dart';
import 'package:FEhViewer/utils/logger.dart';
import 'package:FEhViewer/utils/utility.dart';
import 'package:FEhViewer/values/const.dart';
import 'package:FEhViewer/values/theme_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FavoriteSelectorController extends GetxController
    with StateMixin<List<FavcatItemBean>> {
  final List<FavcatItemBean> favItemBeans = [];

  @override
  void onInit() {
    super.onInit();
    getFavItemBeans().then((List<FavcatItemBean> value) {
      change(value, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error('$err'));
    });
  }

  Future<List<Map<String, String>>> getFavList() async {
    final List<Map<String, String>> favList = EHUtils.getFavListFromProfile();
    if (favList == null || favList.isEmpty) {
      await Api.getFavorite(
        favcat: 'a',
        refresh: true,
      );
    }
    return EHUtils.getFavListFromProfile();
  }

  Future<List<FavcatItemBean>> getFavItemBeans() async {
    logger.v('_getFavItemBeans');
    final List<FavcatItemBean> _favItemBeans = <FavcatItemBean>[];

    try {
      final List<Map<String, String>> favList =
          (await getFavList()) ?? EHConst.favList;

      for (final Map<String, String> catmap in favList) {
        final String favTitle = catmap['favTitle'];
        final String favId = catmap['favId'];

        _favItemBeans.add(
          FavcatItemBean(favTitle, ThemeColors.favColor[favId], favId: favId),
        );
      }

      _favItemBeans
          .add(FavcatItemBean('所有收藏', ThemeColors.favColor['a'], favId: 'a'));

      _favItemBeans
          .add(FavcatItemBean('本地收藏', ThemeColors.favColor['l'], favId: 'l'));
      return _favItemBeans;
    } catch (e, stack) {
      logger.e('$e /n $stack');
      rethrow;
    }
  }

  List<FavcatItemBean> initFavItemBeans() {
    final List<FavcatItemBean> _favItemBeans = <FavcatItemBean>[];
    for (final Map<String, String> catmap in EHConst.favList) {
      final String favTitle = catmap['favTitle'];
      final String favId = catmap['favId'];

      _favItemBeans.add(
        FavcatItemBean(favTitle, ThemeColors.favColor[favId], favId: favId),
      );
    }

    _favItemBeans
        .add(FavcatItemBean('所有收藏', ThemeColors.favColor['a'], favId: 'a'));

    _favItemBeans
        .add(FavcatItemBean('本地收藏', ThemeColors.favColor['l'], favId: 'l'));
    return _favItemBeans;
  }
}

class FavSelectorItemController extends GetxController {
  Rx<Color> colorTap = const Color.fromARGB(0, 0, 0, 0).obs;
  void updateNormalColor() {
    colorTap.value = null;
  }

  void updatePressedColor() {
    colorTap.value =
        CupertinoDynamicColor.resolve(CupertinoColors.systemGrey4, Get.context);
  }
}
