// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
//
// class AdsItemWidget extends StatelessWidget {
//   const AdsItemWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (controller.isLoadingAd.value) {
//       return _loadingAdWidget();
//     } else {
//       if (controller.isShowAd.value) {
//         return FadeInUp(
//           child: CarouselSlider.builder(
//             itemCount: controller.adsViewModel.length,
//             itemBuilder:
//                 (BuildContext context, int itemIndex, int pageViewIndex) =>
//                     Padding(
//               padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
//               child: ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: InkWell(
//                       onTap: () async {
//                         if (controller.adsViewModel[itemIndex].isShowAd) {
//                           if (!await launch(
//                               controller.adsViewModel[itemIndex].linkAd)) {
//                             throw 'Could not launch';
//                           }
//                         }
//                       },
//                       child: _showImage(itemIndex))),
//             ),
//             options: CarouselOptions(
//                 onPageChanged: (index, reason) {
//                   controller.indexImage = index;
//                 },
//                 autoPlay: true,
//                 viewportFraction: 1,
//                 height: controller.adsViewModel[controller.indexImage].heightAd
//                         ?.toDouble() ??
//                     80),
//           ),
//         );
//       }
//       return const SizedBox();
//     }
//   }
//
//   Widget _loadingAdWidget() {
//     return FadeInUp(
//       child: SizedBox(
//         height: 80,
//         child: Padding(
//           padding: const EdgeInsets.only(right: 8.0, left: 8, bottom: 8),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: Image.asset(
//               'assets/img/ads_image.jpg',
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
