






import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:medvantage_patient/app_manager/widgets/text_field/primary_text_field_util.dart';
import 'package:flutter/material.dart';

import '../../app_color.dart';
import '../../theme/text_theme.dart';


class CustomSD extends StatefulWidget {

  final bool? multiSelect;
  final bool? enabled;
  final TextStyle? labelStyle;
  final BoxDecoration? decoration;
  final ValueChanged onChanged;
  final List listToSearch;
  final String? label;
  final String valFrom;
  final IconData? prefixIcon;
  final List? initialValue;
  final bool? hideSearch;
  final double? height;
  final Color? borderColor;
  final double? searchBarHeight;
  final EdgeInsetsGeometry? csPadding;
  final Color? iconColor;

  const CustomSD({Key? key,

    this.multiSelect,
    this.labelStyle,
    this.decoration,
    this.label,
    this.prefixIcon,
    required this.listToSearch,
    this.initialValue,
    this.hideSearch,
    this.height,
    this.borderColor,
    required this.valFrom,
    required this.onChanged, this.enabled, this.searchBarHeight, this.csPadding, this.iconColor,}) : super(key: key);

  @override
  _CustomSDState createState() => _CustomSDState();
}

class _CustomSDState extends State<CustomSD> {

  bool obscure=false;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return CustomSearchableDropDown(
      enabled: widget.enabled,
      searchBarHeight:widget.searchBarHeight?? 64,
      multiSelect: widget.multiSelect??false,
      padding: widget.csPadding?? EdgeInsets.all(10),
      initialValue: widget.initialValue,
      backgroundColor: AppColor.greyDark,
      hideSearch: widget.hideSearch?? false,
      menuHeight: widget.height??80,
      menuMode: true,
      prefixIcon:  Padding(
        padding: widget.prefixIcon==null? EdgeInsets.only(right:0):EdgeInsets.only(right:10),
        child: Icon(widget.prefixIcon??Icons.add,color: widget.iconColor??AppColor.transparent,size: 21,),
      ),
      labelStyle: widget.labelStyle??MyTextTheme.mediumBCN,

      items: widget.listToSearch,
      label: widget.label??'Select Name',
      dropdownItemStyle: MyTextTheme.mediumBCN,


      dropDownMenuItems: widget.listToSearch.map((item) {
        return item[widget.valFrom];
      }).toList(),
      onChanged: (val){
        widget.onChanged(val);
      },
      decoration: widget.decoration??BoxDecoration(
          borderRadius: BorderRadius.circular(PrimaryTextFieldUtil.border),
          color: PrimaryTextFieldUtil.fillColor,
          border: Border.all(color: widget.borderColor??PrimaryTextFieldUtil.borderColor)
      ),

    );
  }
}
