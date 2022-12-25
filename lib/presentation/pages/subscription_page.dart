import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iran_appmarket/iran_appmarket.dart';
import 'package:myket_iap/myket_iap.dart';
// import 'package:myket_flutter/myket_flutter.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:task_par/presentation/pages/subscription/my_ket_subscription_page.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/constants.dart';
import 'package:task_par/presentation/utils/extensions.dart';
import 'package:task_par/presentation/widgets/subscription_card.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.isBottomSheet = false});
  final bool isBottomSheet;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GetStorage getStorage = GetStorage();

  late String avatar;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    print('initer');
    avatar = getStorage.read(Keys.avatarKey);
    _controller.text = getStorage.read(Keys.myNameKey) ?? '';
    // Helper.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Text('صفحه پرداخت و تنظیمات بعد از دریافت توکن خرید از مایکت'),
    // );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.isBottomSheet)
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.all(10),
                ),
              SizedBox(
                height: 12,
              ),
              Material(
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  radius: 45,
                  onTap: () {
                    setState(() {
                      avatar = randomAvatarString(
                        DateTime.now().toIso8601String(),
                      );
                      getStorage.write(Keys.avatarKey, avatar);
                    });
                  },
                  child: CircleAvatar(
                    radius: 45,
                    child: SvgPicture.string(avatar),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  maxLength: 12,
                  style: AppTheme.text1.withBlack,
                  controller: _controller,
                  onChanged: (value) {
                    getStorage.write(Keys.myNameKey, value);
                  },
                  decoration: InputDecoration(
                    hintText: 'نام',
                  ),
                ),
              ),
              SizedBox(height: 420, child: MyKetSubscriptionPage()),

              SubscriptionCardWidget(
                  isLoading: false,
                  backGroundColor: Colors.green,
                  price: 'رایگان',
                  description:
                      'با نصب اپلیکیشن فاکتور پر از تمامی امکانات این برنامه به صورت رایگان استفاده کنید',
                  title: 'نسخه رایگان',
                  icon: 'assets/img/coffee-cup.png',
                  onTap: () async {
                    bool isInstalled = await DeviceApps.isAppInstalled(
                        'com.example.factor_flutter_mobile');
                    if (isInstalled) {
                      showTopSnackBar(
                        Overlay.of(context)!,
                        CustomSnackBar.success(
                          message: 'تبریک نسخه شما رایگان است',
                        ),
                      );
                    } else {
                      // final packageName = (await PackageInfo.fromPlatform()).packageName;
                      // IAppMarket.ofType(AppMarket.myket).showAppPage(packageName);
                      IranAppMarket.showDeveloperApps(
                          AppMarket.myket, 'com.example.factor_flutter_mobile');
                      // MyketFlutter.downloadApplication(
                      //     "com.example.factor_flutter_mobile");
                    }
                  }),
              SizedBox(
                height: 24,
              ),
              // Expanded(child: MyKetSubscriptionPage()),
            ],
          ),
        ),
      ),
    );
  }
}
