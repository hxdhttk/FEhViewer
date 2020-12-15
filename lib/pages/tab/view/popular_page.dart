import 'package:FEhViewer/common/global.dart';
import 'package:FEhViewer/pages/tab/controller/popular_controller.dart';
import 'package:FEhViewer/pages/tab/view/gallery_base.dart';
import 'package:FEhViewer/pages/tab/view/tab_base.dart';
import 'package:FEhViewer/widget/eh_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularListTab extends GetView<PopularController> {
  const PopularListTab({Key key, this.tabIndex, this.scrollController})
      : super(key: key);
  final String tabIndex;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final String _title = 'tab_popular'.tr;
    final CustomScrollView customScrollView = CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: TabPageTitle(
            title: _title,
            isLoading: false,
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await controller.reloadData();
          },
        ),
        SliverSafeArea(
          top: false,
          sliver: _getGalleryList(),
        ),
      ],
    );

    return CupertinoPageScaffold(child: customScrollView);
  }

  Widget _getGalleryList() {
    return controller.obx((state) => getGalleryList(state, tabIndex),
        onLoading: SliverFillRemaining(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 50),
            child: const CupertinoActivityIndicator(
              radius: 14.0,
            ),
          ),
        ), onError: (err) {
      Global.logger.e(' $err');
      return SliverFillRemaining(
        child: Container(
          padding: const EdgeInsets.only(bottom: 50),
          child: GalleryErrorPage(
            onTap: controller.reLoadDataFirst,
          ),
        ),
      );
    });
  }
}