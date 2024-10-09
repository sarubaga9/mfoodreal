// import 'package:flutter/material.dart';
// import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';

// class DropdownCustomReport extends StatefulWidget {
//   final TextEditingController? textController;
//   final String? hintText;
//   final List<String>? items;
//   final TextStyle? hintStyle;
//   final TextStyle? style;
//   final TextStyle? dropdownTextStyle;
//   final IconData? suffixIcon;
//   final double? dropdownHeight;
//   final Color? dropdownBgColor;
//   final InputBorder? textFieldBorder;
//   final EdgeInsetsGeometry? contentPadding;
//   final Function(String)? onItemSelected; // เพิ่มฟังก์ชัน callback

//   const DropdownCustomReport(
//       {super.key,
//       required this.textController,
//       this.hintText,
//       required this.items,
//       this.hintStyle,
//       this.style,
//       this.dropdownTextStyle,
//       this.suffixIcon,
//       this.dropdownHeight,
//       this.dropdownBgColor,
//       this.textFieldBorder,
//       this.contentPadding,
//       this.onItemSelected}); // เพิ่มฟังก์ชัน callback

//   @override
//   State<DropdownCustomReport> createState() => _DropdownCustomReportState();
// }

// class _DropdownCustomReportState extends State<DropdownCustomReport> {
//   bool _isTapped = false;
//   List<String> _filteredList = [];
//   List<String> _subFilteredList = [];

//   @override
//   initState() {
//     _filteredList = widget.items!;
//     _subFilteredList = _filteredList;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ///Text Field
//         Row(
//           children: [
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: TextFormField(
//                 controller: widget.textController,
//                 onChanged: (val) {
//                   setState(() {
//                     _filteredList = _subFilteredList
//                         .where((element) => element.toLowerCase().contains(
//                             widget.textController!.text.toLowerCase()))
//                         .toList();
//                   });
//                 },
//                 validator: (val) => val!.isEmpty ? 'Field can\'t empty' : null,
//                 style: FlutterFlowTheme.of(context).bodyMedium,
//                 onTap: () => setState(() => _isTapped = true),
//                 decoration: InputDecoration(
//                   border:
//                       widget.textFieldBorder ?? const UnderlineInputBorder(),
//                   hintText: widget.hintText ?? "Write here...",
//                   hintStyle: FlutterFlowTheme.of(context).bodyMedium,
//                   suffixIcon: Icon(
//                       widget.suffixIcon ?? Icons.arrow_left_outlined,
//                       size: 25,
//                       color: FlutterFlowTheme.of(context)
//                           .primaryText
//                           .withOpacity(0.7)),
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
//                   isDense: true,
//                   suffixIconConstraints:
//                       BoxConstraints.loose(MediaQuery.of(context).size),
//                 ),
//               ),
//             ),
//           ],
//         ),

//         ///Dropdown Items
//         _isTapped && _filteredList.isNotEmpty
//             ? Container(
//                 height: widget.dropdownHeight ?? 150.0,
//                 color: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: ListView.builder(
//                   itemCount: _filteredList.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         setState(() => _isTapped = !_isTapped);
//                         widget.textController!.text = _filteredList[index];
//                         if (widget.onItemSelected != null) {
//                           widget.onItemSelected!(_filteredList[index]); // เรียกฟังก์ชัน callback
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Text(
//                           _filteredList[index],
//                           style: widget.dropdownTextStyle ??
//                               FlutterFlowTheme.of(context).bodyMedium,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             : SizedBox.shrink(),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';

// class DropdownCustomReport extends StatefulWidget {
//   final TextEditingController? textController;
//   final String? hintText;
//   final List<String>? items;
//   final TextStyle? hintStyle;
//   final TextStyle? style;
//   final TextStyle? dropdownTextStyle;
//   final IconData? suffixIcon;
//   final double? dropdownHeight;
//   final Color? dropdownBgColor;
//   final InputBorder? textFieldBorder;
//   final EdgeInsetsGeometry? contentPadding;
//   final Function(String)? onItemSelected;

//   const DropdownCustomReport({
//     Key? key,
//     required this.textController,
//     this.hintText,
//     required this.items,
//     this.hintStyle,
//     this.style,
//     this.dropdownTextStyle,
//     this.suffixIcon,
//     this.dropdownHeight,
//     this.dropdownBgColor,
//     this.textFieldBorder,
//     this.contentPadding,
//     this.onItemSelected,
//   }) : super(key: key);

//   @override
//   State<DropdownCustomReport> createState() => _DropdownCustomReportState();
// }

// class _DropdownCustomReportState extends State<DropdownCustomReport> {
//   bool _isTapped = false;
//   List<String> _filteredList = [];
//   List<String> _subFilteredList = [];
//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     _filteredList = widget.items!;
//     _subFilteredList = _filteredList;
//     super.initState();
//   }

//   void _showOverlay(BuildContext context) {
//     final renderBox = context.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height,
//         width: size.width,
//         child: Material(
//           elevation: 2.0,
//           child: Container(
//             padding: EdgeInsets.fromLTRB(10 , 0, 10, 0),
//             height: widget.dropdownHeight ?? 150.0,
//             color: widget.dropdownBgColor ?? Colors.white,
//             child: ListView.builder(
//               itemCount: _filteredList.length,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       _isTapped = false;
//                       widget.textController!.text = _filteredList[index];
//                       if (widget.onItemSelected != null) {
//                         widget.onItemSelected!(_filteredList[index]);
//                       }
//                     });
//                     _overlayEntry?.remove();
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Text(
//                       _filteredList[index],
//                       style: widget.dropdownTextStyle ??
//                           FlutterFlowTheme.of(context).bodyMedium,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context)!.insert(_overlayEntry!);
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: TextFormField(
//                 controller: widget.textController,
//                 onChanged: (val) {
//                   setState(() {
//                     _isTapped = true;
//                     _filteredList = _subFilteredList
//                         .where((element) => element.toLowerCase().contains(
//                             widget.textController!.text.toLowerCase()))
//                         .toList();
//                     _removeOverlay();
//                     _showOverlay(context);
//                   });
//                 },
//                 validator: (val) => val!.isEmpty ? 'Field can\'t be empty' : null,
//                 style: FlutterFlowTheme.of(context).bodyMedium,
//                 onTap: () {
//                   setState(() {
//                     _isTapped = true;
//                     _showOverlay(context);
//                   });
//                 },
//                 decoration: InputDecoration(
//                   border:
//                       widget.textFieldBorder ?? const UnderlineInputBorder(),
//                   hintText: widget.hintText ?? "Write here...",
//                   hintStyle: widget.hintStyle ??
//                       FlutterFlowTheme.of(context).bodyMedium,
//                   suffixIcon: Icon(
//                     widget.suffixIcon ?? Icons.arrow_drop_down,
//                     size: 25,
//                     color: FlutterFlowTheme.of(context)
//                         .primaryText
//                         .withOpacity(0.7),
//                   ),
//                   contentPadding: widget.contentPadding ??
//                       const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
//                   isDense: true,
//                   suffixIconConstraints:
//                       BoxConstraints.loose(MediaQuery.of(context).size),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _removeOverlay();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';

// class DropdownCustomReport extends StatefulWidget {
//   final TextEditingController? textController;
//   final String? hintText;
//   final List<String>? items;
//   final TextStyle? hintStyle;
//   final TextStyle? style;
//   final TextStyle? dropdownTextStyle;
//   final IconData? suffixIcon;
//   final double? dropdownHeight;
//   final Color? dropdownBgColor;
//   final Color? textfieldBgColor;
//   final InputBorder? textFieldBorder;
//   final EdgeInsetsGeometry? contentPadding;
//   final Function(String)? onItemSelected;

//   const DropdownCustomReport({
//     Key? key,
//     required this.textController,
//     this.hintText,
//     required this.items,
//     this.hintStyle,
//     this.style,
//     this.dropdownTextStyle,
//     this.suffixIcon,
//     this.dropdownHeight,
//     this.dropdownBgColor,
//     this.textfieldBgColor,
//     this.textFieldBorder,
//     this.contentPadding,
//     this.onItemSelected,
//   }) : super(key: key);

//   @override
//   State<DropdownCustomReport> createState() => _DropdownCustomReportState();
// }

// class _DropdownCustomReportState extends State<DropdownCustomReport> {
//   bool _isTapped = false;
//   List<String> _filteredList = [];
//   List<String> _subFilteredList = [];
//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     _filteredList = widget.items!;
//     _subFilteredList = _filteredList;
//     super.initState();
//   }

//   void _showOverlay(BuildContext context) {
//     final renderBox = context.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);

//     _overlayEntry = OverlayEntry(
//       builder: (context) => GestureDetector(
//         onTap: () {
//           setState(() {
//             _isTapped = false;
//             _removeOverlay();
//           });
//         },
//         child: Material(
//           color: Colors.transparent,
//           child: Stack(
//             children: [
//               Positioned(
//                 left: offset.dx,
//                 top: offset.dy + size.height,
//                 width: size.width,
//                 child: Material(
//                   elevation: 2.0,
//                   child: Container(
//                     height: widget.dropdownHeight ?? 150.0,
//                     color: widget.dropdownBgColor ?? Colors.white,
//                     child: ListView.builder(
//                       itemCount: _filteredList.length,
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: () {
//                             setState(() {
//                               _isTapped = false;
//                               widget.textController!.text = _filteredList[index];
//                               if (widget.onItemSelected != null) {
//                                 widget.onItemSelected!(_filteredList[index]);
//                               }
//                             });
//                             _removeOverlay();
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Text(
//                               _filteredList[index],
//                               style: widget.dropdownTextStyle ??
//                                   FlutterFlowTheme.of(context).bodyMedium,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context)!.insert(_overlayEntry!);
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [

//             Expanded(
//               child: TextFormField(
//                 controller: widget.textController,
//                 onChanged: (val) {
//                   setState(() {
//                     _isTapped = true;
//                     _filteredList = _subFilteredList
//                         .where((element) => element.toLowerCase().contains(
//                             widget.textController!.text.toLowerCase()))
//                         .toList();
//                     _removeOverlay();
//                     _showOverlay(context);
//                   });
//                 },
//                 validator: (val) => val!.isEmpty ? 'Field can\'t be empty' : null,
//                 style: FlutterFlowTheme.of(context).bodyMedium,
//                 onTap: () {
//                   setState(() {
//                     _isTapped = true;
//                     _showOverlay(context);
//                   });
//                 },
//                 decoration: InputDecoration(
//                   fillColor: widget.textfieldBgColor ?? Colors.white,
//                   filled: true,
//                   border:
//                       widget.textFieldBorder ?? const UnderlineInputBorder(),
//                   hintText: widget.hintText ?? "Write here...",
//                   hintStyle: widget.hintStyle ??
//                       FlutterFlowTheme.of(context).bodyMedium,
//                   suffixIcon: Icon(
//                     widget.suffixIcon ?? Icons.arrow_drop_down,
//                     size: 25,
//                     color: FlutterFlowTheme.of(context)
//                         .primaryText
//                         .withOpacity(0.7),
//                   ),
//                   // contentPadding: widget.contentPadding ??
//                   //     const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
//                   isDense: true,
//                   suffixIconConstraints:
//                       BoxConstraints.loose(MediaQuery.of(context).size),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _removeOverlay();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';

class DropdownCustomReport extends StatefulWidget {
  final TextEditingController? textController;
  final FocusNode? textFocus;
  final String? hintText;
  final List<String>? items;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextStyle? dropdownTextStyle;
  final IconData? suffixIcon;
  final double? dropdownHeight;
  final Color? dropdownBgColor;
  final Color? textfieldBgColor;
  final InputBorder? textFieldBorder;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onItemSelected;

  const DropdownCustomReport({
    Key? key,
    required this.textController,
    required this.textFocus,
    this.hintText,
    required this.items,
    this.hintStyle,
    this.style,
    this.dropdownTextStyle,
    this.suffixIcon,
    this.dropdownHeight,
    this.dropdownBgColor,
    this.textfieldBgColor,
    this.textFieldBorder,
    this.contentPadding,
    this.onItemSelected,
  }) : super(key: key);

  @override
  State<DropdownCustomReport> createState() => _DropdownCustomReportState();
}

class _DropdownCustomReportState extends State<DropdownCustomReport> {
  bool _isTapped = false;
  List<String> _filteredList = [];
  List<String> _subFilteredList = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    _filteredList = widget.items!;
    _subFilteredList = _filteredList;
    super.initState();
  }

  void _showOverlay(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          setState(() {
            _isTapped = false;
            _removeOverlay();
          });
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height,
                width: size.width,
                child: Material(
                  elevation: 2.0,
                  child: Container(
                    height: widget.dropdownHeight ?? 150.0,
                    color: widget.dropdownBgColor ?? Colors.white,
                    child: ListView.builder(
                      itemCount: _filteredList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _isTapped = false;
                              widget.textController!.text =
                                  _filteredList[index];
                              if (widget.onItemSelected != null) {
                                widget.onItemSelected!(_filteredList[index]);
                              }
                            });
                            _removeOverlay();
                            FocusScope.of(context).requestFocus(
                                FocusNode()); // Remove focus from TextField
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0),
                            child: Text(
                              _filteredList[index],
                              style: widget.dropdownTextStyle ??
                                  FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                focusNode:  widget.textFocus,
                controller: widget.textController,
                onChanged: (val) {
                  setState(() {
                    _isTapped = true;
                    _filteredList = _subFilteredList
                        .where((element) => element.toLowerCase().contains(
                            widget.textController!.text.toLowerCase()))
                        .toList();
                    _removeOverlay();
                    _showOverlay(context);
                  });
                },
                validator: (val) =>
                    val!.isEmpty ? 'Field can\'t be empty' : null,
                style: FlutterFlowTheme.of(context).bodyMedium,
                onTap: () {
                  setState(() {
                    _isTapped = true;
                    _showOverlay(context);
                  });
                },
                decoration: InputDecoration(
                  fillColor: widget.textfieldBgColor ?? Colors.white,
                  filled: true,
                  border:
                      widget.textFieldBorder ?? const UnderlineInputBorder(),
                  hintText: widget.hintText ?? "Write here...",
                  hintStyle: widget.hintStyle ??
                      FlutterFlowTheme.of(context).bodyMedium,
                  suffixIcon: Icon(
                    widget.suffixIcon ?? Icons.arrow_drop_down,
                    size: 25,
                    color: FlutterFlowTheme.of(context)
                        .primaryText
                        .withOpacity(0.7),
                  ),
                  contentPadding: widget.contentPadding ??
                      const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
                  isDense: true,
                  suffixIconConstraints:
                      BoxConstraints.loose(MediaQuery.of(context).size),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }
}
