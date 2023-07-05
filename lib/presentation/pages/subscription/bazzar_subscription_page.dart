// import 'dart:developer';
// import 'dart:math' as math;
//
// import 'package:animate_do/animate_do.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_poolakey/flutter_poolakey.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:task_par/data/models/factor_product_model/factor_product_model.dart';
// import 'package:task_par/presentation/utils/constants.dart';
// import 'package:task_par/presentation/widgets/subscription_card.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
//
// class BazzarSubscriptionPage extends StatefulWidget {
//   const BazzarSubscriptionPage({Key? key}) : super(key: key);
//
//   @override
//   State<BazzarSubscriptionPage> createState() => _BazzarSubscriptionPageState();
// }
//
// class _BazzarSubscriptionPageState extends State<BazzarSubscriptionPage> {
//   final Map<String, ProductItem> _productsMap = {};
//
//   // int coins = 4;
//   List<Color> bacGroundColor = <Color>[
//     bronzeColor,
//     silverColor,
//     goldColor,
//   ];
//   bool isEnterToBazar = true;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initShop(0);
//     initGetStorage();
//     connectionInternet();
//   }
//
//   Future connectionInternet() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       isLoading = true;
//     }
//   }
//
//   Future<void> _initShop(int tryCount) async {
//     _productsMap["bronze_buy"] =
//         ProductItem('assets/img/bronze-cup.png', false);
//     _productsMap["silver"] = ProductItem('assets/img/silver-cup.png', false);
//     _productsMap["gold"] = ProductItem('assets/img/gold_cup.png', false);
//
//     var message = "pedram";
//     var rsaKey =
//         "MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwDw8GXghtv138eIzcJ8ddtySzrNsrVWe3El9K75FK2aIh6+ufnuah7pmVYPJPQLs8+dK87d3Lm1uWrQCsrjdis+RjxDS1qWZ7Dsg4qUUdiXTQhgTuxLarNT276GOw1nVOYsGwDoc0CZkYNPLvPJ9dv97zrbGans54iFz6K2KDmzaanvCjVUJRi2a9SFRLgNL+SYm9NA9QESElnnlyHXWMoGFImv/i5eyA6WEFx8I+8CAwEAAQ==";
//     bool connected = false;
//     try {
//       connected = await FlutterPoolakey.connect(rsaKey, onDisconnected: () {
//         log('connected${connected}');
//       });
//       isEnterToBazar = true;
//     } on Exception catch (e) {
//       message = e.toString();
//
//       log('messagesss${message}');
//       if (mounted) {
//         setState(() {
//           log('message mou${message}');
//           isEnterToBazar = false;
//         });
//       }
//     }
//     if (!connected) {
//       log('connected${message}');
//       if (mounted) {
//         setState(() {
//           isEnterToBazar = false;
//
//           return;
//         });
//       }
//     } else {
//       log('message con${message}');
//     }
//
//     _reteriveProducts(tryCount);
//   }
//
//   Future<void> _reteriveProducts(int tryCount) async {
//     try {
//       isLoading = true;
//       var purchases = await FlutterPoolakey.getAllPurchasedProducts();
//       var subscribes = await FlutterPoolakey.getAllSubscribedProducts();
//       var allPurchases = <PurchaseInfo>[];
//       allPurchases.addAll(purchases);
//       allPurchases.addAll(subscribes);
//       // for (var purchase in allPurchases) {
//       //   _handlePurchase(purchase);
//       // }
//
//       var skuDetailsList =
//           await FlutterPoolakey.getInAppSkuDetails(_productsMap.keys.toList());
//
//       for (var skuDetails in skuDetailsList) {
//         _productsMap[skuDetails.sku]?.skuDetails = skuDetails;
//
//         // inject purchaseInfo
//         PurchaseInfo? purchaseInfo;
//         for (var p in allPurchases) {
//           if (p.productId == skuDetails.sku) purchaseInfo = p;
//         }
//         _productsMap[skuDetails.sku]?.purchaseInfo = purchaseInfo;
//       }
//       if (mounted) {
//         setState(() {
//           isEnterToBazar = true;
//         });
//       }
//       isLoading = false;
//     } catch (e) {
//       if (tryCount < 1) {
//         showTopSnackBar(
//           Overlay.of(context)!,
//           CustomSnackBar.error(
//             message: 'ابتدا از اتصال حساب خود به کافه بازار مطمعن شوید',
//           ),
//         );
//       }
//       isEnterToBazar = false;
//       print(e.toString());
//
//       Future.delayed(Duration(seconds: math.min(10, tryCount))).then((value) {
//         if (!isEnterToBazar) _initShop(tryCount + 1);
//
//         // isEnterToBazar = false;
//
//         // Future.delayed(const Duration(seconds: 5), () {
//         // Get.back();
//         // });
//       });
//     }
//   }
//
//   // Future<void> _handlePurchase(PurchaseInfo purchase) async {
//   //   log(purchase.originalJson);
//   //   // log(purchase.productId);
//   //   // log(purchase.dataSignature);
//   //   if (purchase.productId == "bronze_buy") {
//   //     if (coins < 5) coins = (coins + 1);
//   //   } else if (purchase.productId == "silver") {
//   //     coins = 5;
//   //   } else if (purchase.productId == "gold") {
//   //     coins = 10;
//   //   }
//   //
//   //   if (_productsMap[purchase.productId]!.consumable) {
//   //     var result = await FlutterPoolakey.consume(purchase.purchaseToken);
//   //     log(result.toString());
//   //     if (!result) {
//   //       log("object");
//   //     }
//   //   }
//   //   if (mounted) {
//   //     setState(() {});
//   //   }
//   // }
//
//   GetStorage getStorage = GetStorage();
//   String subscriptionValue = '';
//
//   initGetStorage() {
//     // isLoading.value = true;
//     Future.delayed(const Duration(milliseconds: 500), () async {
//       // sharedPreferences = await SharedPreferences.getInstance();
//
//       loadSubscription();
//       // isLoading.value = false;
//     });
//   }
//
//   void saveSubscription(String value) {
//     getStorage.write(Keys.subscriptionKey, value);
//   }
//
//   void loadSubscription() {
//     String subscriptionData = getStorage.read(Keys.subscriptionKey) ?? '';
//     if (subscriptionData.isNotEmpty) {
//       subscriptionValue = subscriptionData;
//     }
//     log('loadSubsc${subscriptionData}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final items = _productsMap.values.toList();
//     return WillPopScope(
//       onWillPop: () async {
//         isEnterToBazar = true;
//         return true;
//       },
//       child: Scaffold(
//           // appBar: FactorAppBar(
//           //     title: Padding(
//           //       padding: const EdgeInsets.only(top: 12),
//           //       child: Text(
//           //         'اشتراک',
//           //         style:
//           //             TextStyle(color: Theme.of(context).colorScheme.secondary),
//           //       ),
//           //     ),
//           //     customBackButtonFunction: () {
//           //       Get.back(result: true);
//           //       isEnterToBazar = true;
//           //     }),
//           body:
//               // Padding(
//               //     padding: const EdgeInsets.only(top: 20),
//               //     child:
//               // isEnterToBazar
//               //     ?
//               _listViewBuilder(items)
//           // : FadeInRight(
//           //     child: SingleChildScrollView(
//           //       child: Column(
//           //         crossAxisAlignment: CrossAxisAlignment.center,
//           //         children: [
//           //           Image.asset(
//           //             bazarIcon,
//           //             width: 200,
//           //             height: 150,
//           //             fit: BoxFit.contain,
//           //           ),
//           //           const Padding(
//           //             padding: EdgeInsets.all(8.0),
//           //             child: Text(
//           //               'خطا در ارتباط با اینترنت یا کافه بازار جهت خرید یا ارتقا اشتراک خود،ابتدا وارد حساب کاربری خود در کافه بازار شوید',
//           //               textAlign: TextAlign.center,
//           //               style: TextStyle(fontSize: 18),
//           //             ),
//           //           ),
//           //           const Text(
//           //             'خروج از این صفحه ، بعد از 5 ثانیه',
//           //             style: TextStyle(color: Colors.red),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           ),
//     );
//   }
//
//   FadeInRight _listViewBuilder(List<ProductItem> items) {
//     return FadeInRight(
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           return _itemListSub(index, items);
//         },
//       ),
//     );
//   }
//
//   Widget _itemListSub(int index, List<ProductItem> items) {
//     return SubscriptionCardWidget(
//         isLoading: isLoading,
//         backGroundColor: bacGroundColor[index],
//         price: items[index].skuDetails == null
//             ? '100'
//             : items[index].skuDetails!.price,
//         description: items[index].skuDetails == null
//             ? 'توضیحات اشتراک'
//             : items[index].skuDetails!.description,
//         title: items[index].skuDetails == null
//             ? 'اشتراک'
//             : items[index].skuDetails!.title,
//         icon: items[index].icon,
//         onTap: () async {
//           print('whhhhh${items[index].skuDetails}');
//           if (!isEnterToBazar) {
//             showTopSnackBar(
//               Overlay.of(context)!,
//               CustomSnackBar.error(
//                 message: 'ابتدا از اتصال حساب خود به کافه بازار مطمعن شوید',
//               ),
//             );
//           }
//           if (items[index].skuDetails == null) return;
//           // if (index == 0 && subscriptionValue == 'silver') {
//           //
//           //   return;
//           // } else if (index == 0 && subscriptionValue == 'gold') {
//           //
//           //   return;
//           // } else if (index == 1 && subscriptionValue == 'gold') {
//           //
//           //   return;
//           // }
//           PurchaseInfo? purchaseInfo;
//           try {
//             purchaseInfo =
//                 await FlutterPoolakey.purchase(items[index].skuDetails!.sku);
//             saveSubscription(items[index].skuDetails!.sku);
//             // _handlePurchase(purchaseInfo);
//             showTopSnackBar(
//               Overlay.of(context)!,
//               CustomSnackBar.success(
//                 message: '${items[index].skuDetails?.title} برای شما فعال شد ',
//               ),
//             );
//           } catch (e) {
//             showTopSnackBar(
//               Overlay.of(context)!,
//               CustomSnackBar.error(
//                 message: 'خرید ناموفق مجددا تلاش کنید',
//               ),
//             );
//
//             return;
//           }
//         });
//   }
// }
//
// Color goldColor = const Color(0xffffd700);
// Color silverColor = const Color(0xffc0c0c0);
// Color bronzeColor = const Color(0xffcd7032);
