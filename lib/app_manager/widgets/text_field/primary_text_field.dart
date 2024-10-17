import 'package:get/get.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';

import '../../../common_libs.dart';
import '../../../theme/theme.dart';
import '../../app_color.dart';
import '../../theme/text_theme.dart';

class PrimaryTextField extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int? maxLine;
  final int? maxLength;
  final bool? enabled;
  final bool? boxDecoration;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final ValueChanged? onChanged;
  final Color? borderColor;
  final String? labelText;
  final String? labelText2;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final InputBorder? border;
  final TextStyle? style;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final List<TextInputFormatter>? inputFormatters;
  final double? borderRadius;

  const PrimaryTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.enabled,
    this.boxDecoration,
    this.textAlign,
    this.keyboardType,
    this.decoration,
    this.onChanged,
    this.borderColor,
    this.maxLine,
    this.labelText,
    this.labelText2,
    this.backgroundColor,
    this.hintTextColor,
    this.border,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.style,
    this.inputFormatters,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProviderLd>(context, listen: true);
    return boxDecoration == true
        ? Wrap(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 2),
                child: labelText2 == null
                    ? const SizedBox()
                    : Text(
                        labelText2.toString(),
                        style: themeChange.darkTheme == false
                            ? MyTextTheme.mediumBCB
                            : MyTextTheme.mediumWCB,
                      ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(boxShadow: [
                  // BoxShadow(
                  //     color: themeChange.darkTheme == true
                  //         ? Colors.black26
                  //         : Colors.grey.shade500,
                  //     offset: const Offset(4, 4),
                  //     blurRadius: 4)
                ], borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                    inputFormatters: inputFormatters,
                    cursorColor: AppColor.black,
                    enabled: enabled ?? true,
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    //  style: const TextStyle(color: Colors.white),
                    minLines: maxLine,
                    maxLines: maxLine == null ? 1 : 100,
                    maxLength: maxLength,
                    textAlign: textAlign ?? TextAlign.start,
                    keyboardType: keyboardType,
                    onChanged: onChanged == null
                        ? null
                        : (val) {
                            onChanged!(val);
                          },
                    style: style,
                    // style:  const TextStyle(
                    //   fontSize: 16,
                    //   color: Colors.white70
                    //
                    // ),
                    decoration: decoration ??
                        InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          isDense: true,
                          fillColor: (enabled ?? true)
                              ? backgroundColor ??
                                  PrimaryTextFieldUtil.fillColor
                              : Colors.grey.shade200,
                          counterText: '',
                          //contentPadding: isPasswordField==null? EdgeInsets.all(5):isPasswordField? EdgeInsets.fromLTRB(5,5,5,5):EdgeInsets.all(5),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: hintText,
                          hintStyle: TextStyle(
                            color: hintTextColor ?? AppColor.greyLight,
                            fontSize: 13,
                            fontWeight: FontWeight.normal
                          ),
                          labelText: labelText,
                          labelStyle: MyTextTheme.smallPCB,
                          errorStyle: TextStyle(
                            color: AppColor.red,
                            fontSize: 13,
                          ),

                          suffixIconConstraints: suffixIconConstraints ??
                              const BoxConstraints(
                                  maxHeight: 30,
                                  minHeight: 20,
                                  maxWidth: 40,
                                  minWidth: 40),
                          prefixIconConstraints: prefixIconConstraints ??
                              const BoxConstraints(
                                  maxHeight: 30,
                                  minHeight: 20,
                                  maxWidth: 40,
                                  minWidth: 40),
                          prefixIcon: prefixIcon,
                          suffixIcon: suffixIcon,

                          focusedBorder: border ??
                              OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    borderRadius ??
                                        PrimaryTextFieldUtil.border)),
                                borderSide: BorderSide(
                                    color: borderColor ??
                                        AppColor.primaryColorLight,
                                    width: 1),
                              ),
                          enabledBorder: border ??
                              OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    borderRadius ??
                                        PrimaryTextFieldUtil.border)),
                                borderSide: BorderSide(
                                    color: borderColor ??
                                        PrimaryTextFieldUtil.borderColor,
                                    width: 1),
                              ),
                          disabledBorder: border ??
                              OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    borderRadius ??
                                        PrimaryTextFieldUtil.border)),
                                borderSide: BorderSide(
                                    color: borderColor ??
                                        PrimaryTextFieldUtil.borderColor,
                                    width: 1),
                              ),
                          errorBorder: border ??
                              OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    borderRadius ??
                                        PrimaryTextFieldUtil.border)),
                                borderSide: BorderSide(
                                    color: borderColor ?? AppColor.red,
                                    width: 1),
                              ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                borderRadius ?? PrimaryTextFieldUtil.border)),
                            borderSide: BorderSide(
                                color: borderColor ??
                                    PrimaryTextFieldUtil.borderColor,
                                width: 1),
                          ),
                        ),
                    validator: validator),
              ),
            ],
          )
        : TextFormField(
            inputFormatters: inputFormatters,
            cursorColor: AppColor.black,
            enabled: enabled ?? true,
            controller: controller,
            textInputAction: TextInputAction.done,
            //  style: const TextStyle(color: Colors.white),
            minLines: maxLine,
            maxLines: maxLine == null ? 1 : 100,
            maxLength: maxLength,
            textAlign: textAlign ?? TextAlign.start,
            keyboardType: keyboardType,
            onChanged: onChanged == null
                ? null
                : (val) {
                    onChanged!(val);
                  },
            style: style,
            // style:  const TextStyle(
            //   fontSize: 16,
            //   color: Colors.white70
            //
            // ),
            decoration: decoration ??
                InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  isDense: true,
                  fillColor: (enabled ?? true)
                      ? backgroundColor ?? PrimaryTextFieldUtil.fillColor
                      : Colors.grey.shade200,
                  counterText: '',
                  //contentPadding: isPasswordField==null? EdgeInsets.all(5):isPasswordField? EdgeInsets.fromLTRB(5,5,5,5):EdgeInsets.all(5),
                  contentPadding: const EdgeInsets.all(10),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: hintTextColor ?? AppColor.white,
                    fontSize: 14,
                  ),
                  labelText: labelText,
                  labelStyle: MyTextTheme.smallPCB,
                  errorStyle: TextStyle(
                    color: AppColor.red,
                    fontSize: 14,
                  ),

                  suffixIconConstraints: suffixIconConstraints ??
                      const BoxConstraints(
                          maxHeight: 30,
                          minHeight: 20,
                          maxWidth: 40,
                          minWidth: 40),
                  prefixIconConstraints: prefixIconConstraints ??
                      const BoxConstraints(
                          maxHeight: 30,
                          minHeight: 20,
                          maxWidth: 40,
                          minWidth: 40),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,

                  focusedBorder: border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            borderRadius ?? PrimaryTextFieldUtil.border)),
                        borderSide: BorderSide(
                            color: borderColor ?? AppColor.primaryColorLight,
                            width: 1),
                      ),
                  enabledBorder: border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            borderRadius ?? PrimaryTextFieldUtil.border)),
                        borderSide: BorderSide(
                            color:
                                borderColor ?? PrimaryTextFieldUtil.borderColor,
                            width: 1),
                      ),
                  disabledBorder: border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            borderRadius ?? PrimaryTextFieldUtil.border)),
                        borderSide: BorderSide(
                            color:
                                borderColor ?? PrimaryTextFieldUtil.borderColor,
                            width: 1),
                      ),
                  errorBorder: border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            borderRadius ?? PrimaryTextFieldUtil.border)),
                        borderSide: BorderSide(
                            color: borderColor ?? AppColor.red, width: 1),
                      ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        borderRadius ?? PrimaryTextFieldUtil.border)),
                    borderSide: BorderSide(
                        color: borderColor ?? PrimaryTextFieldUtil.borderColor,
                        width: 1),
                  ),
                ),
            validator: validator);
  }
}
