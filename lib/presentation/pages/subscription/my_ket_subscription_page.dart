import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myket_iap/myket_iap.dart';
import 'package:myket_iap/util/iab_result.dart';
import 'package:myket_iap/util/inventory.dart';
import 'package:myket_iap/util/purchase.dart';
import 'package:task_par/presentation/utils/constants.dart';
import 'package:task_par/presentation/widgets/subscription_card.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyKetSubscriptionPage extends StatefulWidget {
  const MyKetSubscriptionPage({Key? key}) : super(key: key);

  @override
  _MyKetSubscriptionPageState createState() => _MyKetSubscriptionPageState();
}

class _MyKetSubscriptionPageState extends State<MyKetSubscriptionPage> {
  bool _loading = true;

  @override
  void initState() {
    initIab();
    super.initState();
    initGetStorage();
    connectionInternet();
  }

  Future connectionInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      _loading = true;
    }
  }

  GetStorage getStorage = GetStorage();
  String subscriptionValue = '';

  initGetStorage() {
    // isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () async {
      // sharedPreferences = await SharedPreferences.getInstance();

      loadSubscription();
      // isLoading.value = false;
    });
  }

  void saveSubscription(String value) {
    getStorage.write(Keys.subscriptionKey, value);
  }

  void loadSubscription() {
    String subscriptionData = getStorage.read(Keys.subscriptionKey) ?? '';
    if (subscriptionData.isNotEmpty) {
      subscriptionValue = subscriptionData;
    }
    log('loadSubscriptionsssssss${subscriptionData}');
  }

  @override
  void dispose() {
    MyketIAP.dispose();
    super.dispose();
  }

  initIab() async {
    var rsa =
        "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDeGDnyI9H6cmoQbjuRUkGj0Mbgdv7nHK/GuInxnzOPpOIBjmGSNhMUsvUieiokM1e2ZjIjYfX/wOLcO4e4U63jHBJjd20ZP/DlglHnkAXDH5/x6DF8VWgghpS78cPmMflkHDMnaz69IV6jcNTPr/YqnaHZBBM54myjU06+r4M+owIDAQAB";
    var iabResult = await MyketIAP.init(rsaKey: rsa, enableDebugLogging: true);
    if (iabResult?.isFailure() == true) {
      // Oh noes, there was a problem.
      CustomSnackBar.error(
        message: 'ابتدا از اتصال خود به حساب مایکت یا اینترنت مطمعن شوید',
      );

      return;
    }

    try {
      // IAB is fully set up. Now, let's get an inventory of stuff we own.
      print("Setup successful. Querying inventory.");
      var queryInventoryMap =
          await MyketIAP.queryInventory(querySkuDetails: false);
      IabResult inventoryResult = queryInventoryMap[MyketIAP.RESULT];
      Inventory inventory = queryInventoryMap[MyketIAP.INVENTORY];

      // Is it a failure?
      if (inventoryResult.isFailure()) {
        CustomSnackBar.error(
          message: 'ابتدا از اتصال خود به اینترنت مطمعن شوید',
        );
        return;
      }
      print("Query inventory was successful.");
      print('gasPurchasegasPurchase${subscriptionValue}');
    } catch (e) {
      CustomSnackBar.error(
        message: 'ابتدا از اتصال خود به اینترنت مطمعن شوید',
      );
    }

    setState(() => _loading = false);
  }

  buyFactor(int index) async {
    setState(() => _loading = true);

    String payload = "";

    try {
      var purchaseResultMap = await MyketIAP.launchPurchaseFlow(
          sku: skuBuy(index), payload: payload);
      IabResult purchaseResult = purchaseResultMap[MyketIAP.RESULT];
      Purchase purchase = purchaseResultMap[MyketIAP.PURCHASE];

      if (purchaseResult.isFailure()) {
        showTopSnackBar(
          Overlay.of(context)!,
          CustomSnackBar.error(
            message: 'خرید ناموفق مجددا تلاش کنید',
          ),
        );

        setState(() => _loading = false);

        return;
      }
      saveSubscription(purchase.mSku);
      Navigator.pop(context, true);

      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.success(
          message: '${titleCard(index)} برای شما فعال شد ',
        ),
      );

      setState(() => _loading = false);
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: 'خرید ناموفق مجددا تلاش کنید',
        ),
      );

      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        // isEnterToBazar = true;
        return true;
      },
      child: Scaffold(
        // appBar: FactorAppBar(
        //     title: Padding(
        //       padding: const EdgeInsets.only(top: 12),
        //       child: Text(
        //         'اشتراک',
        //         style:
        //             TextStyle(color: Theme.of(context).colorScheme.secondary),
        //       ),
        //     ),
        //     customBackButtonFunction: () {
        //       Get.back(result: true);
        //       // isEnterToBazar = true;
        //     }),
        body:
            // isEnterToBazar
            //     ?
            _listSubscription(),
      ),
    ));
  }

  Widget _listSubscription() {
    return FadeInRight(
      child: Column(children: _itemListSub()),
    );
  }

  List<Widget> _itemListSub() {
    return List.generate(
        3,
        (index) => SubscriptionCardWidget(
            isLoading: _loading,
            backGroundColor: colorsCard[index],
            price: priceCard(index),
            description: descriptionCard(index),
            title: titleCard(index),
            icon: iconCard(index),
            onTap: _loading ? null : () => buyFactor(index)));
  }

  String titleCard(int index) {
    switch (index) {
      case 0:
        return 'اشتراک برنزی';
      case 1:
        return 'اشتراک نقره ای';
      default:
        return 'اشتراک طلایی';
    }
  }

  String iconCard(int index) {
    switch (index) {
      case 0:
        return 'assets/img/bronze-cup.png';
      case 1:
        return 'assets/img/silver-cup.png';
      default:
        return 'assets/img/gold_cup.png';
    }
  }

  String priceCard(int index) {
    switch (index) {
      case 0:
        return '9,000 تومان';
      case 1:
        return '29,000 تومان';
      default:
        return '39,000 تومان';
    }
  }

  String descriptionCard(int index) {
    switch (index) {
      case 0:
        return '29 تسک به صورت دائمی و دسته بندی نامحدود بدون اشتراک سالانه';
      case 1:
        return '59 تسک به صورت دائمی و دسته بندی نامحدود بدون اشتراک سالانه';
      default:
        return 'بینهایت فاکتور به صورت دائمی و مشتریان نامحدود بدون اشتراک سالانه + حذف تبلیغات';
    }
  }

  List<Color> colorsCard = <Color>[
    bronzeColor,
    silverColor,
    goldColor,
  ];

  String skuBuy(int index) {
    switch (index) {
      case 0:
        return 'bronze_buy';
      case 1:
        return 'silver';
      default:
        return 'gold';
    }
  }
}

Color goldColor = const Color(0xffffd700);
Color silverColor = const Color(0xffc0c0c0);
Color bronzeColor = const Color(0xffcd7032);
