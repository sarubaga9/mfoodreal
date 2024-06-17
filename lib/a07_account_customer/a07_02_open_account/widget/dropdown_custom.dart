import 'package:flutter/material.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';

class DropdownCustom extends StatefulWidget {
  final TextEditingController? textController;
  final String? hintText;
  final List<String>? items;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextStyle? dropdownTextStyle;
  final IconData? suffixIcon;
  final double? dropdownHeight;
  final Color? dropdownBgColor;
  final InputBorder? textFieldBorder;
  final EdgeInsetsGeometry? contentPadding;

  const DropdownCustom(
      {super.key,
      required this.textController,
      this.hintText,
      required this.items,
      this.hintStyle,
      this.style,
      this.dropdownTextStyle,
      this.suffixIcon,
      this.dropdownHeight,
      this.dropdownBgColor,
      this.textFieldBorder,
      this.contentPadding});

  @override
  State<DropdownCustom> createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  bool _isTapped = false;
  List<String> _filteredList = [];
  List<String> _subFilteredList = [];

  @override
  initState() {
    _filteredList = widget.items!;
    _subFilteredList = _filteredList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Text Field
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: widget.textController,
                onChanged: (val) {
                  setState(() {
                    _filteredList = _subFilteredList
                        .where((element) => element.toLowerCase().contains(
                            widget.textController!.text.toLowerCase()))
                        .toList();
                  });
                },
                validator: (val) => val!.isEmpty ? 'Field can\'t empty' : null,
                style: FlutterFlowTheme.of(context).bodyMedium,
                onTap: () => setState(() => _isTapped = true),
                decoration: InputDecoration(
                  border:
                      widget.textFieldBorder ?? const UnderlineInputBorder(),
                  hintText: widget.hintText ?? "Write here...",
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium,

                  suffixIcon: Icon(
                      widget.suffixIcon ?? Icons.arrow_left_outlined,
                      size: 25,
                      color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.7)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
                  isDense: true,
                  suffixIconConstraints:
                      BoxConstraints.loose(MediaQuery.of(context).size),
                  // suffix: InkWell(
                  //   onTap: () {
                  //     widget.textController!.clear();
                  //     setState(() => _filteredList = widget.items!);
                  //   },
                  //   child: const Icon(Icons.clear, color: Colors.grey),
                  // ),
                ),
              ),
            ),
          ],
        ),

        ///Dropdown Items
        _isTapped && _filteredList.isNotEmpty
            ? Container(
                height: widget.dropdownHeight ?? 150.0,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  itemCount: _filteredList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() => _isTapped = !_isTapped);
                        widget.textController!.text = _filteredList[index];
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _filteredList[index],
                          style: widget.dropdownTextStyle ??
                              FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    );
                  },
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
