
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_color.dart';
import '../../theme/text_theme.dart';




// ignore: must_be_immutable
class MyTextField2 extends StatefulWidget {

  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int? maxLine;
  final int? maxLength;
  final bool? isPasswordField;
  final bool? enabled;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final ValueChanged? onChanged;
  final Color? borderColor;
  List<TextInputFormatter>? inputFormatters;
  final BorderRadius? borderRadius;
  final String? labelText;
  final Widget? label;
  final List? searchedList;
  final String? searchParam;
  final ValueChanged? onTapSearchedData;
  final Function? onTap;
  final bool? showSearchedList;
  final TextStyle? style;

  MyTextField2({Key? key, this.hintText, this.controller,
    this.isPasswordField,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.enabled,
    this.textAlign,
    this.keyboardType,
    this.decoration,
    this.onChanged,
    this.inputFormatters,
    this.borderColor,
    this.borderRadius,
    this.maxLine,
    this.labelText,
    this.label,
    this.searchedList,
    this.searchParam,
    this.onTapSearchedData,
    this.onTap,
    this.showSearchedList, this.style,
  }) : super(key: key);

  @override
  _MyTextField2State createState() => _MyTextField2State();
}

class _MyTextField2State extends State<MyTextField2> {

  bool obscure=false;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isPasswordField??false){
      obscure=widget.isPasswordField!;
      setState(() {

      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
            onTap: (){
              if(widget.onTap!=null) {
                widget.onTap!();
              }
            },
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled??true,
            cursorColor: AppColor.black,
            controller: widget.controller,
            minLines: widget.maxLine,
            maxLines: widget.maxLine==null? 1:100,
            obscureText: widget.isPasswordField==null? false:obscure,
            maxLength: widget.maxLength,
            textAlign: widget.textAlign?? TextAlign.start,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged==null? null:(val){
              widget.onChanged!(val);
            },
            style: widget.style?? MyTextTheme.mediumWCN,
            decoration: widget.decoration??InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: widget.label,
              filled: true,
              isDense: true,
              fillColor: (widget.enabled?? true)?Colors.transparent:AppColor.transparent,
              counterText: '',
              //contentPadding: widget.isPasswordField==null? EdgeInsets.all(5):widget.isPasswordField? EdgeInsets.fromLTRB(5,5,5,5):EdgeInsets.all(5),
              contentPadding: const EdgeInsets.all(12),
              hintText: widget.hintText,
              hintStyle: MyTextTheme.mediumPCN.copyWith(
                  color: AppColor.white
              ),
              labelText: widget.label!=null? null:widget.labelText,

              labelStyle: MyTextTheme.largeBCN.copyWith(
                  color: AppColor.greyDark
              ),
              alignLabelWithHint: true,
              errorStyle: MyTextTheme.mediumBCB.copyWith(
                  color: AppColor.red
              ),
              prefixIcon: widget.prefixIcon,
              suffixIconConstraints: const BoxConstraints(maxHeight:28,),
              suffixIcon:  (widget.isPasswordField==null || widget.isPasswordField==false)? widget.suffixIcon:IconButton(
                splashRadius: 5,
                icon: obscure? Icon(Icons.visibility,
                  color: AppColor.primaryColor,
                )
                    : Icon(Icons.visibility_off,
                  color:  AppColor.primaryColor,),
                onPressed: (){
                  setState(() {
                    obscure=!obscure;
                  });

                },),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(
              //     color: Colors.white,
              //     width: 2
              //   )
              // ),
              // disabledBorder: UnderlineInputBorder(
              //     borderSide: BorderSide(
              //         color: Colors.white,
              //         width: 2
              //     )
              // ),
              // enabledBorder: UnderlineInputBorder(
              //     borderSide: BorderSide(
              //         color: Colors.white,
              //         width: 2
              //     )
              // ),
              // border: UnderlineInputBorder(
              //     borderSide: BorderSide(
              //         color: Colors.white,
              //         width: 2
              //     )
              // ),
              // errorBorder: UnderlineInputBorder(
              //     borderSide: BorderSide(
              //         color: Colors.white,
              //         width: 2
              //     )
              // ),
              // focusedErrorBorder: UnderlineInputBorder(
              //     borderSide: BorderSide(
              //         color: Colors.white,
              //         width: 2
              //     )
              // ),

              focusedBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius?? const BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                    color: widget.borderColor?? AppColor.greyDark,
                    width: 1
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius?? const BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: widget.borderColor?? AppColor.greyDark,

                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius?? const BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: widget.borderColor?? AppColor.greyDark,

                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius?? const BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: widget.borderColor?? AppColor.greyDark,

                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius?? const BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: widget.borderColor?? AppColor.greyDark,
                ),
              ),
            ),
            validator: widget.validator
        ),
        AnimatedContainer(
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.greyVeryLight,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              )
          ),
          height: ((widget.showSearchedList?? true)
              &&
              (widget.searchedList!=null  &&  widget.searchedList!.isNotEmpty)
          )? 200: 0,
          duration: const Duration(milliseconds: 500),
          child: ListView.builder(
              itemCount: widget.searchedList==null? 0: widget.searchedList!.length,
              itemBuilder: (context,index){
                return TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black, padding: const EdgeInsets.all(0),
                      minimumSize: const Size(0,0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap
                  ),
                  onPressed: (){
                    widget.onTapSearchedData!(widget.searchedList![index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(widget.searchedList![index][widget.searchParam].toString(),
                            textAlign: TextAlign.start,
                            style: MyTextTheme.mediumBCN,),
                        ),
                      ],
                    ),
                  ),
                );

              }),
        )
      ],
    );
  }
}




