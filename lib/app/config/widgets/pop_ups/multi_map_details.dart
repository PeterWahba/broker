import 'package:broker/app/config/style/app_color.dart';
import 'package:broker/app/modules/layout/data/model/get_last_ads_response_model.dart';
import 'package:broker/app/modules/list_view/views/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiMapDetails extends StatelessWidget {
  final List<Advertisements> advertisements;
  const MultiMapDetails({super.key, required this.advertisements});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
      title: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.close, color: AppColors.grey),
      ),
      content: SizedBox(
        height: 300.h, // Set a fixed height
        width: 300.w, // Set a fixed width if needed
        child: ListView.separated(
          itemBuilder:
              (context, index) =>
                  ListItem(advertisements: advertisements[index]),
          separatorBuilder: (context, index) => 15.verticalSpaceFromWidth,
          itemCount: advertisements.length,
        ),
      ),
    );
  }
}
