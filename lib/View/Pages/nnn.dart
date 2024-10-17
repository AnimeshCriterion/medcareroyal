
import 'package:flutter/material.dart';

// class InfiniteScrollScreen extends StatefulWidget {
//   @override
//   _InfiniteScrollScreenState createState() => _InfiniteScrollScreenState();
// }
//
// class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
//   final List<int> _items = List.generate(20, (index) => index);
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.position.atEdge) {
//         if (_scrollController.position.pixels != 0) {
//           _loadMoreItems();
//         }
//       }
//     });
//   }
//
//   Future<void> _loadMoreItems() async {
//     if (_isLoading) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     await Future.delayed(Duration(seconds: 2)); // Simulate network delay
//
//     setState(() {
//       _items.addAll(List.generate( 10, (index) => _items.length + index));
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Infinite Scrolling Example')),
//       body: Column(
//         children: [
//           Text(_scrollController.position.pixels.toString()),
//           Text(_scrollController.position.pixels.toString()),
//           Semantics(
//             label: 'This is a button that says hello',
//             child: ElevatedButton(
//               onPressed: () {},
//               child: Text(_scrollController.position.atEdge.toString()),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _items.length + (_isLoading ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == _items.length) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 return ListTile(title: Text('Item ${_items[index]}'));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';

class CustomSearchableDropDowns extends StatefulWidget {
  List items = [];
  List? initialValue;
  double? searchBarHeight;
  Color? primaryColor;
  Color? backgroundColor;
  Color? dropdownBackgroundColor;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? menuPadding;
  String? label;
  String? dropdownHintText;
  TextStyle? labelStyle;
  TextStyle? dropdownItemStyle;
  String? hint = '';
  String? multiSelectTag;
  int? initialIndex;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool? hideSearch;
  bool? enabled;
  bool? showClearButton;
  bool? menuMode;
  double? menuHeight;
  bool? multiSelect;
  bool? multiSelectValuesAsWidget;
  bool? showLabelInMenu;
  String? itemOnDialogueBox;
  Decoration? decoration;
  final TextAlign? labelAlign;
  final ValueChanged onChanged;

  CustomSearchableDropDowns({
    required this.items,
    required this.label,
    required this.onChanged,
    this.hint,
    this.initialValue,
    this.labelAlign,
    this.searchBarHeight,
    this.primaryColor,
    this.padding,
    this.menuPadding,
    this.labelStyle,
    this.enabled,
    this.showClearButton,
    this.itemOnDialogueBox,
    this.prefixIcon,
    this.suffixIcon,
    this.menuMode,
    this.menuHeight,
    this.initialIndex,
    this.multiSelect,
    this.multiSelectTag,
    this.multiSelectValuesAsWidget,
    this.hideSearch,
    this.decoration,
    this.showLabelInMenu,
    this.dropdownItemStyle,
    this.backgroundColor,
    this.dropdownBackgroundColor,
    this.dropdownHintText,
  });

  @override
  _CustomSearchableDropDownsState createState() =>
      _CustomSearchableDropDownsState();
}

class _CustomSearchableDropDownsState extends State<CustomSearchableDropDowns>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  String onSelectLabel = '';
  final searchC = TextEditingController();
  List menuData = [];
  List mainDataListGroup = [];
  List newDataList = [];
  List selectedValues = [];
  late AnimationController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    mainDataListGroup = widget.items;
    newDataList = mainDataListGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: widget.decoration,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.backgroundColor ??
                      Theme.of(context).colorScheme.surface,
                  padding: widget.padding ?? EdgeInsets.all(8),
                ),
                onPressed: widget.enabled == null || widget.enabled == true
                    ? () {
                  menuData.clear();
                  if (widget.items.isNotEmpty) {
                    for (int i = 0; i < widget.items.length; i++) {
                      menuData.add(widget.items[i].toString());
                    }
                    mainDataListGroup = menuData;
                    newDataList = mainDataListGroup;
                    searchC.clear();
                    if (_menuController.value != 1) {
                      _menuController.forward();
                    } else {
                      _menuController.reverse();
                    }
                  }
                }
                    : null,
                child: Row(
                  children: [
                    widget.prefixIcon ?? SizedBox(),
                    Expanded(
                      child: Text(
                        onSelectLabel.isEmpty
                            ? widget.label ?? 'Select Value'
                            : onSelectLabel,
                        style: widget.labelStyle ??
                            Theme.of(context).textTheme.bodyLarge,
                        textAlign: widget.labelAlign ?? TextAlign.start,
                      ),
                    ),
                    widget.suffixIcon ?? Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _menuController,
              child: searchBox(),
            ),
          ],
        ),
        Visibility(
          visible: widget.menuMode ?? false,
          child: _showMenuMode(),
        ),
      ],
    );
  }

  Widget _showMenuMode() {
    return SizeTransition(
      sizeFactor: _menuController,
      child: mainScreen(setState),
    );
  }

  Future<void> showDialogueBox(context) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Padding(
            padding: widget.menuPadding ?? EdgeInsets.all(15),
            child: StatefulBuilder(builder: (context, setState) {
              return Material(
                color: Colors.transparent,
                child: mainScreen(setState),
              );
            }),
          );
        }).then((valueFromDialog) {
      setState(() {});
    });
  }

  searchBox() {
    return Visibility(
      visible: widget.hideSearch == null ? true : !widget.hideSearch!,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Material(
          elevation: 2.0,
          shadowColor: Theme.of(context).colorScheme.shadow,
          borderRadius: BorderRadius.circular(8),
          child: TextFormField(
            controller: searchC,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              suffixIcon: Icon(Icons.search, color: widget.primaryColor),
              hintText: widget.dropdownHintText ?? 'Search here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (v) {
              onItemChanged(v);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Widget mainScreen(setState) {
    return Padding(
      padding: widget.menuPadding ?? EdgeInsets.all(0),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(12),
        color: widget.dropdownBackgroundColor ??
            Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: (widget.showLabelInMenu ?? false) && widget.label != null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.label.toString(),
                  style: widget.labelStyle ??
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: widget.primaryColor ?? Colors.blue,
                      ),
                ),
              ),
            ),
            Visibility(
              visible: widget.multiSelect ?? false,
              child: Row(
                children: [
                  TextButton(
                    child: Text('Select All'),
                    onPressed: () {
                      setState(() {
                        selectedValues = List.from(newDataList);
                      });
                    },
                  ),
                  TextButton(
                    child: Text('Clear All'),
                    onPressed: () {
                      setState(() {
                        selectedValues.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
            widget.menuMode ?? false
                ? SizedBox(
              height: widget.menuHeight ?? 150,
              child: mainList(setState),
            )
                : Expanded(
              child: mainList(setState),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    if (widget.menuMode ?? false) {
                      _menuController.reverse();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Visibility(
                  visible: widget.multiSelect ?? false,
                  child: TextButton(
                    child: Text('Done'),
                    onPressed: () {
                      var sendList = [];
                      for (int i = 0; i < menuData.length; i++) {
                        if (selectedValues.contains(menuData[i])) {
                          sendList.add(widget.items[i]);
                        }
                      }
                      widget.onChanged(jsonEncode(sendList));
                      if (widget.menuMode ?? false) {
                        _menuController.reverse();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mainList(setState) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: newDataList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = newDataList[index];
          return ListTile(
            leading: widget.multiSelect ?? false
                ? Checkbox(
              value: selectedValues.contains(item),
              onChanged: (bool? value) {
                if (value != null && value) {
                  setState(() {
                    selectedValues.add(item);
                  });
                } else {
                  setState(() {
                    selectedValues.remove(item);
                  });
                }
              },
            )
                : null,
            title: Text(
              item.toString(),
              // style: widget.dropdownItemStyle ??
            ),
            onTap: () {
              setState(() {
                onSelectLabel = item.toString();
                widget.onChanged(widget.items[index]);
                if (widget.menuMode ?? false) {
                  _menuController.reverse();
                } else {
                  Navigator.pop(context);
                }
              });
            },
          );
        },
      ),
    );
  }

  void onItemChanged(String value) {
    setState(() {
      newDataList = mainDataListGroup
          .where((string) =>
          string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}


