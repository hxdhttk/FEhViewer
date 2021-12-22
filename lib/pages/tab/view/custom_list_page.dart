import 'package:blur/blur.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fehviewer/fehviewer.dart';
import 'package:fehviewer/pages/tab/controller/custom_list_controller.dart';
import 'package:fehviewer/pages/tab/view/gallery_base.dart';
import 'package:fehviewer/pages/tab/view/tab_base.dart';
import 'package:fehviewer/utils/cust_lib/persistent_header_builder.dart';
import 'package:fehviewer/utils/cust_lib/sliver/sliver_persistent_header.dart';
import 'package:fehviewer/widget/refresh.dart';
import 'package:flutter/cupertino.dart' hide CupertinoTabBar;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/size_cache_widget.dart';
import 'package:easy_animated_tabbar/easy_animated_tabbar.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:english_words/english_words.dart';

import '../comm.dart';
import 'constants.dart';
import 'tab_base.dart';

const Color _kDefaultNavBarBorderColor = Color(0x4D000000);
const Border _kDefaultNavBarBorder = Border(
  bottom: BorderSide(
    color: _kDefaultNavBarBorderColor,
    width: 0.0, // One physical pixel.
    style: BorderStyle.solid,
  ),
);

const double kTopTabbarHeight = 40.0;

List<String> titleList = [
  '测试',
  '奇奇怪怪的东西',
  '自定义测试2',
  '列表',
  '列表',
  '列表',
  '列表',
  '列表',
  '列表',
  '只可意会',
  '不可言传',
  '点点点',
];

class CustomList extends StatefulWidget {
  const CustomList({Key? key, this.costomListTag}) : super(key: key);

  final String? costomListTag;

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  late final CustomListController controller;
  final EhTabController ehTabController = EhTabController();
  final LinkScrollBarController linkScrollBarController =
      LinkScrollBarController();
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    controller = Get.find<CustomListController>(tag: widget.costomListTag);

    controller.initStateForListPage(
      context: context,
      ehTabController: ehTabController,
    );
  }

  Widget _buildTopBar(
      BuildContext context, double offset, double maxExtentCallBackValue) {
    double iconOpacity = 0.0;
    final transparentOffset = maxExtentCallBackValue - 60;
    if (offset < transparentOffset) {
      iconOpacity = 1 - offset / transparentOffset;
    }

    return Container(
      height: maxExtentCallBackValue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: getNavigationBar(context),
          ),
          Stack(
            // fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: [
              Blur(
                blur: 10,
                blurColor: CupertinoTheme.of(context)
                    .barBackgroundColor
                    .withOpacity(1),
                colorOpacity: 0.7,
                child: Container(
                  height: kTopTabbarHeight,
                ),
              ),
              ClipRect(
                child: Container(
                  decoration: const BoxDecoration(
                    border: _kDefaultNavBarBorder,
                  ),
                  padding: EdgeInsets.only(
                    left: context.mediaQueryPadding.left,
                    right: context.mediaQueryPadding.right,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: kTopTabbarHeight,
                          child: LinkScrollBar(
                            width: context.mediaQuery.size.width,
                            controller: linkScrollBarController,
                            titleList: titleList,
                            selectIndex: 0,
                            onItemChange: (index) =>
                                pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease),
                          ),
                          // color: CupertinoColors.systemBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CupertinoNavigationBar getNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      transitionBetweenRoutes: false,
      // backgroundColor:
      //     CupertinoTheme.of(context).barBackgroundColor.withOpacity(1),
      // border: null,
      border: Border(
        bottom: BorderSide(
          color: CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.2),
          width: 0.1, // 0.0 means one physical pixel
        ),
      ),
      padding: const EdgeInsetsDirectional.only(end: 4),
      middle: GestureDetector(
        onTap: () => controller.srcollToTop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('自定义'),
            Obx(() {
              if (controller.isBackgroundRefresh)
                return const CupertinoActivityIndicator(
                  radius: 10,
                ).paddingSymmetric(horizontal: 8);
              else
                return const SizedBox();
            }),
          ],
        ),
      ),
      leading: controller.getLeading(context),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 页码跳转按钮
          CupertinoButton(
            minSize: 40,
            padding: const EdgeInsets.only(right: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: CupertinoDynamicColor.resolve(
                      CupertinoColors.activeBlue, context),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => Text(
                    '${controller.curPage.value + 1}',
                    style: TextStyle(
                        color: CupertinoDynamicColor.resolve(
                            CupertinoColors.activeBlue, context)),
                  )),
            ),
            onPressed: () {
              controller.jumpToPage();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget scrollView = CustomScrollView(
      cacheExtent: kTabViewCacheExtent,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverFloatingPinnedPersistentHeader(
          delegate: SliverFloatingPinnedPersistentHeaderBuilder(
            minExtentProtoType: SizedBox(
              height: context.mediaQueryPadding.top + kTopTabbarHeight,
            ),
            maxExtentProtoType: SizedBox(
                height: kMinInteractiveDimensionCupertino +
                    context.mediaQueryPadding.top +
                    kTopTabbarHeight),
            builder: _buildTopBar,
          ),
        ),
        EhCupertinoSliverRefreshControl(
          onRefresh: () => controller.onRefresh(),
        ),
        SliverSafeArea(
          top: false,
          bottom: false,
          sliver: _getGallerySliverList(),
          // sliver: _getTabbar(),
        ),
        Obx(() {
          return EndIndicator(
            pageState: controller.pageState,
            loadDataMore: controller.loadDataMore,
          );
        }),
      ],
    );

    final wordList = generateWordPairs().take(100).toList();
    final headerMaxHeight = kMinInteractiveDimensionCupertino +
        context.mediaQueryPadding.top +
        kTopTabbarHeight;

    final Widget scrollView2 = ExtendedNestedScrollView(
      floatHeaderSlivers: true,
      onlyOneScrollInBody: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                context),
            sliver: SliverPersistentHeader(
              floating: true,
              pinned: true,
              delegate: FooSliverPersistentHeaderDelegate(
                builder: (context, offset, _) => _buildTopBar(
                  context,
                  offset,
                  headerMaxHeight,
                ),
                minHeight: context.mediaQueryPadding.top + kTopTabbarHeight,
                maxHeight: headerMaxHeight,
              ),
            ),
          )
        ];
      },
      body: Builder(builder: (context) {
        return PageView(
          controller: pageController,
          children: [
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                    padding: EdgeInsets.only(
                        top: context.mediaQueryPadding.top + kTopTabbarHeight),
                    sliver: EhCupertinoSliverRefreshControl(
                      onRefresh: () => controller.onRefresh(),
                    )),
                SliverSafeArea(
                  top: false,
                  bottom: false,
                  sliver: _getGallerySliverList(),
                  // sliver: _getTabbar(),
                ),
                Obx(() {
                  return EndIndicator(
                    pageState: controller.pageState,
                    loadDataMore: controller.loadDataMore,
                  );
                }),
              ],
            ),
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverOverlapInjector(
                    handle:
                        ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                            context)),
                SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Text(wordList[index].asString);
                    }, childCount: 100),
                    itemExtent: 50.0),
              ],
            ),
            ...titleList
                .map((e) => Center(
                      child: Text(e),
                    ))
                .toList()
              ..removeAt(0)
              ..removeAt(0)
          ],
          onPageChanged: (index) {
            linkScrollBarController.scrollToItem(index);
          },
        );
      }),
    );

    return CupertinoPageScaffold(
      // navigationBar: navigationBar,
      child: SizeCacheWidget(child: scrollView2),
    );
  }

  Widget _getGallerySliverList() {
    return controller.obx(
        (List<GalleryItem>? state) {
          return getGallerySliverList(
            state,
            controller.tabTag,
            maxPage: controller.maxPage,
            curPage: controller.curPage.value,
            lastComplete: controller.lastComplete,
            key: controller.sliverAnimatedListKey,
            lastTopitemIndex: controller.lastTopitemIndex,
          );
        },
        onLoading: SliverFillRemaining(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 50),
            child: const CupertinoActivityIndicator(
              radius: 14.0,
            ),
          ),
        ),
        onError: (err) {
          logger.e(' $err');
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
