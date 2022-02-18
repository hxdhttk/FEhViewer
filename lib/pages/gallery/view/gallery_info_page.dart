import 'package:fehviewer/common/service/controller_tag_service.dart';
import 'package:fehviewer/common/service/theme_service.dart';
import 'package:fehviewer/const/const.dart';
import 'package:fehviewer/network/api.dart';
import 'package:fehviewer/pages/gallery/controller/gallery_page_controller.dart';
import 'package:fehviewer/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const kTextStyle = TextStyle(fontSize: 13);

class GalleryInfoPage extends StatelessWidget {
  const GalleryInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CupertinoPageScaffold(
        backgroundColor: !ehTheme.isDarkMode
            ? CupertinoColors.secondarySystemBackground
            : null,
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Gallery info'),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: GetBuilder<GalleryPageController>(
              // init: GalleryPageController(),
              tag: pageCtrlTag,
              id: GetIds.PAGE_VIEW_HEADER,
              builder: (GalleryPageController controller) {
                if (controller.galleryItem == null) {
                  return const SizedBox.shrink();
                }

                final _infoMap = {
                  'Gid': controller.galleryItem!.gid,
                  'Token': controller.galleryItem!.token,
                  'Url':
                      '${controller.galleryItem!.url?.startsWith('http') ?? false ? '' : Api.getBaseUrl()}${controller.galleryItem!.url}',
                  'Title': controller.galleryItem!.englishTitle,
                  'Jpn Title': controller.galleryItem!.japaneseTitle,
                  'Thumb': controller.galleryItem!.imgUrl,
                  'Category': controller.galleryItem!.category,
                  'Uploader': controller.galleryItem!.uploader,
                  'Posted': controller.galleryItem!.postTime,
                  'Language': controller.galleryItem!.language,
                  'Pages': controller.galleryItem!.filecount,
                  'Size': controller.galleryItem!.filesizeText,
                  'Favorite count': controller.galleryItem!.favoritedCount,
                  'Favorited':
                      '${controller.galleryItem!.favcat?.isNotEmpty ?? false}',
                  'Favorite': controller.galleryItem!.favTitle ?? '',
                  'Rating count': controller.galleryItem!.ratingCount,
                  'Rating': '${controller.galleryItem!.rating}',
                  'Torrents': controller.galleryItem!.torrentcount,
                  // 'Torrents Url': controller.galleryItem.torrentcount,
                };

                return CupertinoFormSection.insetGrouped(
                  backgroundColor: Colors.transparent,
                  margin: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                  children: _infoMap.entries
                      .map((e) => TextItem(
                            prefixText: e.key,
                            initialValue: e.value,
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

class TextItem extends StatelessWidget {
  const TextItem({Key? key, required this.prefixText, this.initialValue})
      : super(key: key);
  final String prefixText;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showToast('Copied to clipboard');
        Clipboard.setData(ClipboardData(text: initialValue));
      },
      child: CupertinoFormRow(
        prefix: Text(
          prefixText,
          style: kTextStyle.copyWith(fontWeight: FontWeight.w500),
        ).paddingOnly(right: 20),
        child: SelectableText(
          initialValue ?? '',
          style: kTextStyle,
        ),
      ).paddingSymmetric(horizontal: 8, vertical: 8),
    );
  }
}
