import 'dart:typed_data';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vura/utils/color_util.dart';
import 'package:vura/widgets/obx_widget.dart';

import 'logic.dart';

class PhoneContactsPage extends StatelessWidget {
  const PhoneContactsPage({super.key});

  PhoneContactsLogic get logic => Get.find<PhoneContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("联系人")),
        body: BaseWidget(
            logic: logic,
            builder: (logic) {
              return ListView.separated(
                  itemBuilder: (_, index) {
                    return Container(
                        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                        child: Row(children: [
                          _ContactImage(id: logic.list[index].id),
                          SizedBox(width: 13.w),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(logic.list[index].displayName,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600, fontSize: 15.sp, color: ColorUtil.color_333333)),
                              SizedBox(height: 4.h),
                              Text(logic.list[index].phones.isNotEmpty ? logic.list[index].phones.first.number : "",
                                  style: GoogleFonts.roboto(fontSize: 13.sp, color: ColorUtil.color_333333))
                            ]),
                          )
                        ]));
                  },
                  separatorBuilder: (_, index) => const Divider(height: 0),
                  itemCount: logic.list.length);
            }));
  }
}

class _ContactImage extends StatefulWidget {
  const _ContactImage({required this.id});

  final String id;

  @override
  createState() => __ContactImageState();
}

class __ContactImageState extends State<_ContactImage> {
  late Future<Uint8List?> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = FastContacts.getContactImage(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: _imageFuture,
        builder: (context, snapshot) => SizedBox(
            width: 46.r,
            height: 46.r,
            child: snapshot.hasData
                ? Image.memory(snapshot.data!, gaplessPlayback: true)
                : Image.asset("assets/images/default_face.webp")));
  }
}
