
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_color.dart';
import '../../theme/text_theme.dart';




class PasswordField extends StatefulWidget {

  final String? hintText;
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
  final List<TextInputFormatter>? inputFormatters;

  const PasswordField({Key? key, this.hintText, this.controller,
    this.validator,
    this.prefixIcon,
    this.maxLength,
    this.enabled,
    this.textAlign,
    this.keyboardType,
    this.decoration,
    this.onChanged,
    this.borderColor,
    this.maxLine,
    this.labelText,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool obscure=true;








  @override
  Widget build(BuildContext context) {
    return       TextFormField(
      inputFormatters: widget.inputFormatters,
        cursorColor: AppColor.black,
        enabled: widget.enabled??true,
        controller: widget.controller,
        minLines: widget.maxLine,
        maxLines: widget.maxLine==null? 1:100,
        obscureText: obscure,
        maxLength: widget.maxLength,
        textAlign: widget.textAlign?? TextAlign.start,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged==null? null:(val){
          widget.onChanged!(val);
        },
        style:  const TextStyle(
          fontSize: 16,

        ),
        decoration: widget.decoration??InputDecoration(
          filled: true,
          isDense: true,
          fillColor: (widget.enabled??true)?
          PrimaryTextFieldUtil.fillColor:Colors.grey.shade200,
          counterText: '',
          //contentPadding: isPasswordField==null? EdgeInsets.all(5):isPasswordField? EdgeInsets.fromLTRB(5,5,5,5):EdgeInsets.all(5),
          contentPadding: const EdgeInsets.all(10),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColor.grey,
            fontSize: 16,
          ),
          labelText: widget.labelText,
          labelStyle: MyTextTheme.smallPCB,
          errorStyle: TextStyle(
            color: AppColor.red,
            fontSize: 14,
          ),

          suffixIconConstraints: const BoxConstraints(
              maxHeight: 30,
              minHeight: 20,
              maxWidth: 40,
              minWidth: 40
          ),
          prefixIconConstraints: const BoxConstraints(
              maxHeight: 30,
              minHeight: 20,
              maxWidth: 40,
              minWidth: 40
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: IconButton(
            splashRadius: 5,
            icon: obscure? Icon(Icons.visibility,
              color: AppColor.primaryColorLight,)
                : Icon(Icons.visibility_off,
              color:  AppColor.primaryColorLight,),
            onPressed: (){
              setState(() {
                obscure=!obscure;
              });

            },),

          focusedBorder:  OutlineInputBorder(
            borderRadius:  const BorderRadius.all(Radius.circular(PrimaryTextFieldUtil.border)),
            borderSide: BorderSide(
                color: widget.borderColor??AppColor.primaryColorLight,
                width: 1
            ),
          ),
          enabledBorder:   OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(PrimaryTextFieldUtil.border)),
            borderSide: BorderSide(
                color: widget.borderColor??PrimaryTextFieldUtil.borderColor,
                width: 1
            ),
          ),
          disabledBorder:  OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(PrimaryTextFieldUtil.border)),
            borderSide: BorderSide(
                color: widget.borderColor??PrimaryTextFieldUtil.borderColor,
                width: 1
            ),
          ),
          errorBorder:    OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(PrimaryTextFieldUtil.border)),
            borderSide: BorderSide(
                color: widget.borderColor??AppColor.red,
                width: 1
            ),
          ),
          focusedErrorBorder:  OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(PrimaryTextFieldUtil.border)),
            borderSide: BorderSide(
                color: widget.borderColor??PrimaryTextFieldUtil.borderColor,
                width: 1
            ),
          ),
        ),
        validator: widget.validator
    );
  }
}


