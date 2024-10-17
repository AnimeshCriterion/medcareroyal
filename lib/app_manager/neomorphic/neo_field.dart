
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import '../app_color.dart';
import '../theme/text_theme.dart';


class NeoField extends StatelessWidget {

  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int? maxLine;
  final int? maxLength;
  final bool? enabled;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final ValueChanged? onChanged;
  final Color? borderColor;
  final String? labelText;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final InputBorder? border;
  final TextStyle? style;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final List<TextInputFormatter>? inputFormatters;
  final double? borderRadius;


  const NeoField({Key? key, this.hintText, this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.enabled,
    this.textAlign,
    this.keyboardType,
    this.decoration,
    this.onChanged,
    this.borderColor,
    this.maxLine,
    this.labelText,
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
    return
      TextFormField(
          inputFormatters: inputFormatters,
          cursorColor: AppColor.black,
          enabled: enabled??true,
          controller: controller,
          textInputAction: TextInputAction.done,
          //  style: const TextStyle(color: Colors.white),
          minLines: maxLine,
          maxLines: maxLine==null? 1:100,
          maxLength: maxLength,
          textAlign: textAlign?? TextAlign.start,
          keyboardType: keyboardType,
          onChanged: onChanged==null? null:(val){
            onChanged!(val);
          },

          style:  const TextStyle(
            fontSize: 16,

          ),
          decoration: decoration??InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            isDense: true,
            fillColor: (enabled??true)?
            backgroundColor??
                PrimaryTextFieldUtil.fillColor:Colors.grey.shade200,
            counterText: '',
            //contentPadding: isPasswordField==null? EdgeInsets.all(5):isPasswordField? EdgeInsets.fromLTRB(5,5,5,5):EdgeInsets.all(5),
            contentPadding:  const EdgeInsets.all(10),
            hintText: hintText,
            hintStyle: TextStyle(
              color:hintTextColor?? AppColor.grey,
              fontSize: 16,
            ),
            labelText: labelText,
            labelStyle: MyTextTheme.smallPCB,
            errorStyle: TextStyle(
              color: AppColor.red,
              fontSize: 14,
            ),

            suffixIconConstraints: suffixIconConstraints??const BoxConstraints(
                maxHeight: 30,
                minHeight: 20,
                maxWidth: 40,
                minWidth: 40
            ),
            prefixIconConstraints:prefixIconConstraints?? const BoxConstraints(
                maxHeight: 30,
                minHeight: 20,
                maxWidth: 40,
                minWidth: 40
            ),
            prefixIcon: prefixIcon,
            suffixIcon:  suffixIcon,

            focusedBorder:  border??OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(borderRadius??PrimaryTextFieldUtil.border)),
              borderSide: BorderSide(
                  color: borderColor??AppColor.primaryColorLight,
                  width: 1
              ),
            ),
            enabledBorder:  border?? OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(borderRadius??PrimaryTextFieldUtil.border)),
              borderSide: BorderSide(
                  color: borderColor??PrimaryTextFieldUtil.borderColor,
                  width: 1
              ),
            ),
            disabledBorder:  border?? OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(borderRadius??PrimaryTextFieldUtil.border)),
              borderSide: BorderSide(
                  color: borderColor??PrimaryTextFieldUtil.borderColor,
                  width: 1
              ),
            ),
            errorBorder:   border?? OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(borderRadius??PrimaryTextFieldUtil.border)),
              borderSide: BorderSide(
                  color: borderColor??AppColor.red,
                  width: 1
              ),
            ),
            focusedErrorBorder:  OutlineInputBorder(
              borderRadius:  BorderRadius.all(Radius.circular(borderRadius??PrimaryTextFieldUtil.border)),
              borderSide: BorderSide(
                  color: borderColor??PrimaryTextFieldUtil.borderColor,
                  width: 1
              ),
            ),
          ),
          validator: validator
      );
  }
}







