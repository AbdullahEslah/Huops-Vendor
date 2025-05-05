import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:huops/constants/app_languages.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/custom_grid_view.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Select your preferred language"
            .tr()
            .text
            .xl.white
            .semiBold
            .make()
            .py20()
            .px12(),
        UiSpacer.divider(),

        //
        CustomGridView(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          padding: EdgeInsets.all(12),
          dataSet: AppLanguages.codes,
          itemBuilder: (ctx, index) {
            return VStack(
              [
                //
                Flag.fromString(
                  AppLanguages.flags[index],
                  height: 40,
                  width: 40,
                ),
                UiSpacer.verticalSpace(space: 5),
                //
                AppLanguages.names[index].text.gray300.lg.make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
              alignment: MainAxisAlignment.center,
            ).box.roundedSM.make().glassMorphic().onTap(() {
              _onSelected(context, AppLanguages.codes[index]);
            });
          },
        ).expand(),
      ],
    ).hHalf(context).glassMorphic();
  }

  void _onSelected(BuildContext context, String code) async {
    await AuthServices.setLocale(code);
    await Utils.setJiffyLocale();
    //
    await translator.setNewLanguage(
      context,
      newLanguage: code,
      remember: true,
      restart: true,
    );
    //
    context.pop();
  }
}
