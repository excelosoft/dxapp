// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_dashboard/style/colors.dart';

import '../../functions/mainger_provider.dart';

class CustomDropdownFormField<T> extends StatefulWidget {
  final String? label;
  final String? placeHolderText;
  final String? hintText;
  final double borderRadius;
  final T? value;
  final List<dynamic> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final IconData? righticon;
  final TextStyle? hintStyle;
  final String? title;
  final double labelFontSize;
  final FontWeight? labelFontWeight;
  final bool isMandatory;
  final FocusNode? focusNode;
  final bool disabled;
  final bool readOnly; // Add new property for read-only mode
  final double? width;

  const CustomDropdownFormField({
    Key? key,
    this.label,
    this.placeHolderText,
    this.hintText,
    this.borderRadius = 10,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.righticon,
    this.hintStyle = const TextStyle(color: Colors.grey),
    this.title,
    this.labelFontSize = 16,
    this.labelFontWeight,
    this.isMandatory = false,
    this.focusNode,
    this.disabled = false,
    this.readOnly = false, // Initialize read-only to false by default
    this.width,
  }) : super(key: key);

  @override
  State<CustomDropdownFormField<T>> createState() => _CustomDropdownFormFieldState<T>();
}

class _CustomDropdownFormFieldState<T> extends State<CustomDropdownFormField<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.label,
                    style: TextStyle(
                      fontFamily: GoogleFonts.dmSans().fontFamily,
                      color: Colors.white,
                      fontSize: widget.labelFontSize,
                      fontWeight: widget.labelFontWeight,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: AbsorbPointer( // Use AbsorbPointer to disable interaction when read-only
              absorbing: widget.readOnly,
              child: DropdownButtonFormField<T>(

                dropdownColor: Colors.white,
                focusNode: widget.focusNode,
                value: widget.value,
                isExpanded: true,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                isDense: true,
                padding: const EdgeInsets.all(0),
                focusColor: Colors.transparent,
                icon: const Icon(Icons.expand_more, color: Colors.transparent),
                alignment: Alignment.center,
                items: widget.items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      '$item',
                      softWrap: true,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
                onChanged: widget.disabled ? null : widget.onChanged,
                validator: widget.validator,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: widget.hintText,
                  hoverColor: Colors.transparent,
                  suffixIcon: const Icon(Icons.expand_more),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: const BorderSide()),
                  errorStyle: const TextStyle(height: 0),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  labelStyle: const TextStyle(fontSize: 12),
                  focusColor: Colors.white,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: const BorderSide()),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  errorMaxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchableDropdownFormField<T> extends StatefulWidget {
  final String? label;
  final String? placeHolderText;
  final String? hintText;
  final double borderRadius;
  final T? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(T?)? validator;
  final IconData? righticon;
  final TextStyle? hintStyle;
  final String? title;
  final double labelFontSize;
  final FontWeight? labelFontWeight;
  final bool isMandatory;
  final FocusNode? focusNode;
  final bool disabled;
  final double? width;

  const CustomSearchableDropdownFormField({
    Key? key,
    this.label,
    this.placeHolderText,
    this.hintText,
    this.borderRadius = 10,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.righticon,
    this.hintStyle = const TextStyle(color: Colors.grey),
    this.title,
    this.labelFontSize = 16,
    this.labelFontWeight,
    this.isMandatory = false,
    this.focusNode,
    this.disabled = false,
    this.width,
  }) : super(key: key);

  @override
  State<CustomSearchableDropdownFormField<T>> createState() => _CustomSearchableDropdownFormFieldState<T>();
}

class _CustomSearchableDropdownFormFieldState<T> extends State<CustomSearchableDropdownFormField<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.label,
                    style: TextStyle(
                      fontFamily: GoogleFonts.dmSans().fontFamily,
                      color: Colors.white,
                      fontSize: widget.labelFontSize,
                      fontWeight: widget.labelFontWeight,
                    ),
                  ),
                  // if (widget.isMandatory)
                  //   const TextSpan(
                  //     text: ' *',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.red,
                  //     ),
                  //   ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: widget.width,
            child: DropdownSearch<String>(
              selectedItem: widget.value.toString(),
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                disabledItemFn: (String s) => s.startsWith('I'),
              ),
              items: widget.items,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "Select Model",
                  // label: Text('Select Model'),
                  isDense: true,

                  contentPadding: EdgeInsets.only(left: 10, top: 12),
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMultiSearchableDropdownFormField<T> extends StatefulWidget {
  final String? label;
  final String? placeHolderText;
  final String? hintText;
  final double borderRadius;
  final T? value;
  final List<String>? initValue;
  final List<String> items;
  final ValueChanged<List<String?>> onChanged;
  final String? Function(T?)? validator;
  final IconData? righticon;
  final TextStyle? hintStyle;
  final String? title;
  final double labelFontSize;
  final FontWeight? labelFontWeight;
  final bool isMandatory;
  final FocusNode? focusNode;
  final bool disabled;
  final double? width;

  const CustomMultiSearchableDropdownFormField({
    Key? key,
    this.label,
    this.placeHolderText,
    this.hintText,
    this.borderRadius = 10,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.righticon,
    this.hintStyle = const TextStyle(color: Colors.grey),
    this.title,
    this.labelFontSize = 16,
    this.labelFontWeight,
    this.isMandatory = false,
    this.focusNode,
    this.disabled = false,
    this.width, this.initValue,
  }) : super(key: key);

  @override
  State<CustomMultiSearchableDropdownFormField<T>> createState() => _CustomMultiSearchableDropdownFormFieldState<T>();
}

class _CustomMultiSearchableDropdownFormFieldState<T> extends State<CustomMultiSearchableDropdownFormField<T>> {
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<String>>();

  List<String> _selectedValues = []; // Track selected values

  @override
  void initState() {
    super.initState();
   final value= Provider.of<QuotationListValue>(context, listen: false);
    // Initialize selected values with the provided initial values
    if (widget.initValue != null) {
      value._selectedValues = widget.initValue!;
    }
  }
  void clearSelectedValues() {
    setState(() {
      _selectedValues.clear(); // Clear selected values
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuotationListValue>(
  builder: (context, provider, child) {
  return Container(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your label code here
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: widget.width,
            child: DropdownSearch<String>.multiSelection(
              key: _popupCustomValidationKey,
              items: widget.items,
              selectedItems: provider._selectedValues, // Pass selected values
              popupProps: PopupPropsMultiSelection.menu(
                validationWidgetBuilder: (ctx, selectedItems) {
                  return Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        color: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        height: 50,
                        child: Text(
                          'Select',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        textColor: Colors.white,
                        onPressed: () {

                          List<String> selectedValues = _popupCustomValidationKey.currentState!.popupGetSelectedItems;
                          setState(() {
                            provider._selectedValues = selectedValues; // Update selected values
                          });
                          widget.onChanged(selectedValues);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  fillColor: Colors.white,
                  //hintText: widget.hintText,
                  isDense: true,
                  contentPadding: EdgeInsets.only(left: 10, top: 12,bottom: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
);
  }
}











// class SearchableDropdown extends StatefulWidget {
//   final List<dynamic> items;
//   final String labelText;
//   final String hintText;
//   final String? value;
//   final Function(String?) onChanged;
//   final FormFieldValidator<String>? validator;
//   const SearchableDropdown({
//     Key? key,
//     required this.items,
//     required this.labelText,
//     required this.hintText,
//     this.value,
//     required this.onChanged,
//     this.validator,
//   }) : super(key: key);

//   @override
//   SearchableDropdownState createState() => SearchableDropdownState();
// }

// class SearchableDropdownState extends State<SearchableDropdown> {
//   // String? _selectedValue;
//   String _searchQuery = '';
//   bool _isListOpen = false;
//   TextEditingController textEditingController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     textEditingController = TextEditingController();
//   }

//   void _handleChange(String? value) {
//     setState(() {
//       // _selectedValue = value;
//       _searchQuery = '';
//       textEditingController.text = value!;
//       widget.onChanged(value);
//     });
//     _toggleListVisibility();
//   }

//   List get _filteredItems {
//     if (_searchQuery.isEmpty) {
//       return widget.items;
//     } else {
//       return widget.items.where((item) => item.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
//     }
//   }

//   void _toggleListVisibility() {
//     setState(() {
//       _isListOpen = !_isListOpen;
//     });
//   }

//   void _openList() {
//     setState(() {
//       _isListOpen = true;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     textEditingController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width / 3.5,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(widget.labelText),
//           const SizedBox(height: 10),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: TextFormField(
//               controller: textEditingController,
//               validator: widget.validator,
//               decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 isDense: true,
//                 disabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                         // color: AppColor.inputFieldBorderColor,
//                         )),
//                 errorStyle: const TextStyle(height: 0),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.red, width: 1),
//                 ),
//                 counterText: "",
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: _isListOpen
//                     ? IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: _toggleListVisibility,
//                       )
//                     : null,

//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(
//                         // color: AppColor.inputFieldBorderColor,
//                         )),
//                 // isDense: true,
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(
//                       // color: AppColor.primary,
//                       ),
//                 ),
//                 errorMaxLines: 1,
//               ),
//               onChanged: (value) => setState(() => _searchQuery = value),
//               onTap: _openList,
//             ),
//           ),
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             height: _isListOpen ? (_filteredItems.isEmpty ? 190 : 190) : 0,
//             child: ListView.separated(
//               separatorBuilder: (context, index) => const Divider(),
//               shrinkWrap: true,
//               itemCount: _filteredItems.length,
//               itemBuilder: (context, index) {
//                 final item = _filteredItems[index];
//                 return ListTile(
//                   title: Text(item),
//                   onTap: () {
//                     _handleChange(item);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class QuotationListValue extends ChangeNotifier{
  List<String> _selectedValues = [];

  List<String> get selectedValues=>_selectedValues;
  void resetData(){
    _selectedValues=[];
    notifyListeners();
  }

  bool _editing= false;
  bool get editing=>_editing;
  void setEditing(bool value){
    _editing =value;
    notifyListeners();

  }
  
}