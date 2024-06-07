// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/constants/utils/text_utility.dart';
import 'package:responsive_dashboard/constants/validation/basic_validation.dart';
import 'package:responsive_dashboard/style/colors.dart';

Widget textFieldForWarranty({
  required BuildContext context,
  required TextEditingController textEditingController,
  required String hintext,
  required String labelText,
  Color? labelColor,
  VoidCallback? onTap,
  Function(String)? onChange,
  bool isRightIcon = false,
  bool showLabel = true,
  IconData? rightIcon,
  bool isDigitOnly = false,
  bool readOnly = false,
  bool isvalidationTrue = false,
  double? width,
  String? initialvalue,
}) {
  return CustomTextInput(
    showLabel: showLabel,
    controller: textEditingController,
    labelText: labelText,
    labelColor: labelColor,
    rightIcon: rightIcon,
    onlyDigits: isDigitOnly,
    readonly: readOnly,
    ontap: onTap,
    onChanged: onChange,

    width: width,
    initialvalue: initialvalue,
    validator: (value) => isvalidationTrue ? validateForNameField(props: labelText, value: value) : null,
  );
  // return Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(
  //       labelText,
  //       style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
  //     ),
  //     SizedBox(
  //       height: 10,
  //     ),
  //     Container(
  //       width: MediaQuery.of(context).size.width / 3.5,
  //       // height: 40,
  //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
  //       padding: EdgeInsets.symmetric(horizontal: 15),
  //       child: TextFormField(
  //         onTap: onTap,
  //         readOnly: readOnly,
  //         inputFormatters: isDigitOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
  //         controller: textEditingController,
  //         decoration: InputDecoration(hintText: hintext, suffixIcon: isRightIcon ? Icon(rightIcon) : null),
  //         validator: (value) => isvalidationTrue ? validateForNameField(props: labelText, value: value) : null,
  //       ),
  //     ),
  //   ],
  // );
}

Widget textFieldForFullWidth({
  required BuildContext context,
  required TextEditingController textEditingController,
  required String hintext,
  required String labelText,
  VoidCallback? onTap,
  Function(String)? onchage,
  bool isRightIcon = false,
  IconData? rightIcon,
  bool isDigitOnly = false,
  bool readOnly = false,
  double? width,
  bool isValidationtrue = false,
  int maxlines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        // height: 40,
        width: width,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          onTap: onTap,
          onChanged: onchage,

          maxLines: maxlines,

          readOnly: readOnly,
          inputFormatters: isDigitOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
          controller: textEditingController,
          decoration:
              InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 14), hintText: hintext, suffixIcon: isRightIcon ? Icon(rightIcon) : null),
          validator: (value) => isValidationtrue ? validateForNameField(props: labelText, value: value) : null,
        ),
      ),
    ],
  );
}

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double marginTop;
  final double marginbottom;
  final double marginLeft;
  final double margiRight;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final double? width;
  final AlignmentGeometry alignment;
  final Decoration boxDecoration;

  const CustomContainer(this.child,
      {this.margiRight = 0,
      this.marginbottom = 0,
      this.marginLeft = 0,
      this.marginTop = 0,
      this.paddingTop = 0,
      this.paddingLeft = 0,
      this.paddingBottom = 0,
      this.paddingRight = 0,
      this.width,
      this.alignment = Alignment.topLeft,
      this.boxDecoration = const BoxDecoration()});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: boxDecoration,
      width: width,
      margin: EdgeInsets.only(
        top: marginTop,
        bottom: marginbottom,
        left: marginLeft,
        right: margiRight,
      ),
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: child,
    );
  }
}

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final Color? labelColor;
  final bool showLabel;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback? ontap;
  final Widget? label;
  final bool enabled;
  final FocusNode? focusnode;
  final String? hintText;
  final IconData? leftIcon;
  final bool? obscureText;
  final bool? readonly;
  final bool? autofocus;
  final IconData? rightIcon;
  final bool isDense;
  final String? initialvalue;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Function(String text)? onFieldSubmitted;
  final TextStyle? hintstyle;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final EdgeInsetsGeometry? margin;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final bool onlyDigits;
  final bool isDotRequired;
  final bool obsecureText;
  final double? width;

  const CustomTextInput({
    Key? key,
    required this.controller,
    this.labelText,
    this.labelColor,
    this.showLabel = true,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
    this.ontap,
    this.label,
    this.enabled = true,
    this.focusnode,
    this.hintText,
    this.leftIcon,
    this.obscureText = false,
    this.readonly = false,
    this.autofocus = false,
    this.rightIcon,
    this.isDense = true,
    this.initialvalue,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.onFieldSubmitted,
    this.hintstyle = const TextStyle(color: Colors.grey),
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.margin = const EdgeInsets.all(0),
    this.autofillHints,
    this.textInputAction,
    this.onlyDigits = false,
    this.isDotRequired = false,
    this.obsecureText = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Responsive.isMobile(context) ? EdgeInsets.only(top: showLabel ? 20 : 0) : margin,
      width: width ?? MediaQuery.of(context).size.width / 3.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel) ...[
            AppText(
              text: labelText.toString(),
              textColor: labelColor != null ? labelColor : Colors.white,
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 5 : 10,
            ),
          ],
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              inputFormatters: onlyDigits
                  ? isDotRequired
                      ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                      : <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          LengthLimitingTextInputFormatter(10),
                        ]
                  : null,
              autofocus: autofocus ?? false,
              textInputAction: textInputAction ?? TextInputAction.done,
              focusNode: focusnode,
              autofillHints: autofillHints,
              enabled: enabled,
              onTap: ontap,
              onFieldSubmitted: onFieldSubmitted,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.dmSans().fontFamily,
                fontSize: 12,
              ),
              controller: controller,
              decoration: InputDecoration(
                isDense: isDense,
                fillColor: Colors.white,
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    )),
                errorStyle: const TextStyle(height: 0),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
                // label: label,
                counterText: "",
                contentPadding: contentPadding,
                // labelText: labelText,
                hintText: labelText,
                hintStyle: hintstyle,
                prefixIcon: leftIcon != null ? Icon(leftIcon, color: Colors.black) : null,
                suffixIcon: rightIcon != null ? Icon(rightIcon, color: Colors.black) : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        // color: AppColor.inputFieldBorderColor,
                        )),
                // isDense: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      // color: AppColor.primary,
                      ),
                ),
                errorMaxLines: 1,
              ),
              obscureText: obsecureText,
              maxLength: maxLength,
              keyboardType: keyboardType,
              onChanged: onChanged,
              validator: validator,
              readOnly: readonly!,
              onEditingComplete: onEditingComplete,
              initialValue: initialvalue,
              maxLines: maxLines,
              minLines: minLines,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAuthTextInput extends StatefulWidget {
  final TextEditingController controller;
  final GlobalKey<FormState>? formKey;
  final String? labelText;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback? ontap;
  final Widget? label;
  final bool enabled;
  final FocusNode? focusnode;
  final String? hintText;
  final IconData? leftIcon;
  final bool? obscureText;
  final bool? readonly;
  final bool? autofocus;
  final IconData? rightIcon;
  final bool isDense;
  final String? initialvalue;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Function(String text)? onFieldSubmitted;
  final TextStyle? hintstyle;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final EdgeInsetsGeometry? margin;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final bool onlyDigits;
  final Function? onFieldFocusLost;

  const CustomAuthTextInput(
      {Key? key,
      required this.controller,
      this.labelText,
      this.formKey,
      this.onFieldFocusLost,
      this.hintText,
      this.isDense = true,
      this.leftIcon,
      this.focusnode,
      this.ontap,
      this.hintstyle = const TextStyle(color: Colors.grey),
      this.rightIcon,
      this.obscureText = false,
      this.keyboardType,
      this.onEditingComplete,
      this.onChanged,
      this.maxLength,
      this.validator,
      this.initialvalue,
      this.textInputAction,
      this.maxLines = 1,
      this.minLines = 1,
      this.readonly = false,
      this.label,
      this.enabled = true,
      this.autofocus = false,
      this.contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      this.onFieldSubmitted,
      this.autofillHints,
      this.onlyDigits = false,
      this.margin = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  CustomAuthTextInputState createState() => CustomAuthTextInputState();
}

class CustomAuthTextInputState extends State<CustomAuthTextInput> {
  bool? _obscureText = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    widget.focusnode?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!widget.focusnode!.hasFocus && widget.controller.text.isNotEmpty) {
      widget.onFieldFocusLost?.call();
      setState(() {
        hasError = true;
      });
      // _validate();
    }
  }

  // void _validate() {
  //   if (widget.validator != null) {
  //     String? error = widget.validator!(widget.controller.text);
  //     if (error != null) {
  //       // widget.validator?.call(widget.controller.text);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(error),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          enableInteractiveSelection: false,
          autovalidateMode: hasError ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          inputFormatters: widget.onlyDigits
              ? <TextInputFormatter>[
                  // FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
          autofocus: widget.autofocus!,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          focusNode: widget.focusnode,
          autofillHints: widget.autofillHints,
          enabled: widget.enabled,
          onTap: widget.ontap,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontFamily: GoogleFonts.dmSans().fontFamily,
            fontSize: 12,
          ),
          controller: widget.controller,
          decoration: InputDecoration(
            isDense: widget.isDense,
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    // color: AppColor.inputFieldBorderColor,
                    )),
            errorStyle: const TextStyle(height: 0),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            label: widget.label,
            counterText: "",
            contentPadding: widget.contentPadding,
            labelText: widget.labelText,
            hintText: widget.hintText,
            hintStyle: widget.hintstyle,
            prefixIcon: widget.leftIcon != null ? Icon(widget.leftIcon, color: Colors.black) : null,
            suffixIcon: widget.rightIcon != null
                ? IconButton(
                    icon: Icon(
                      widget.rightIcon,
                      color: Colors.black,
                    ),
                    iconSize: 18,
                    onPressed: widget.obscureText == true
                        ? () {
                            setState(() {
                              _obscureText = !_obscureText!;
                            });
                          }
                        : null,
                  )
                : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    // color: AppColor.inputFieldBorderColor,
                    )),
            // isDense: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 68, 96, 239),
              ),
            ),
            errorMaxLines: 1,
          ),
          obscureText: _obscureText!,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          validator: (v) {
            return widget.validator!(v);
          },
          readOnly: widget.readonly!,
          onEditingComplete: widget.onEditingComplete,
          initialValue: widget.initialvalue,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.focusnode?.removeListener(_onFocusChange);
    super.dispose();
  }
}

//-----------------------------------------Button------------------------------------>

class CustomButton extends StatefulWidget {
  final String text;
  final bool? isBorder;
  final double? width;
  final bool titleLeft;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Color lefticonColor;
  final Color righticonColor;
  final double opacity;
  final double? fontsize;
  final double height;
  final TextStyle? textStyle;
  final Color? borderColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final FontWeight fontWeight;
  final double letterSpacing;
  final TextAlign textAlign;
  final bool? isAttachments;
  final double? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.isBorder = true,
    this.width,
    this.titleLeft = false,
    required this.onPressed,
    this.buttonColor = AppColors.buttonColor,
    this.textColor = Colors.white,
    this.leftIcon,
    this.rightIcon,
    this.lefticonColor = Colors.white,
    this.righticonColor = Colors.white,
    this.opacity = 1,
    this.fontsize = 16,
    this.height = 50.0,
    this.textStyle,
    this.borderColor = Colors.grey,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
    this.fontWeight = FontWeight.w500,
    this.letterSpacing = 0,
    this.textAlign = TextAlign.center,
    this.isAttachments = false,
    this.borderRadius = 8,
    this.margin = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return CustomInkWell(
      onTap: widget.onPressed,
      child: Opacity(
        opacity: widget.opacity,
        child: Container(
          alignment: Alignment.center,
          height: widget.height,
          width: widget.width,
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(
            border: widget.isBorder! ? Border.all(color: widget.borderColor!) : null,
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(widget.borderRadius!),
          ),
          child: Row(
            mainAxisAlignment: widget.titleLeft ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              if (widget.leftIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    widget.leftIcon,
                    color: widget.lefticonColor,
                    size: 24,
                  ),
                ),
              if (widget.isAttachments == false) ...[
                AppText(
                  textAlign: TextAlign.center,
                  text: widget.text,
                  textColor: widget.textColor,
                  fontsize: widget.fontsize!,
                  letterspacing: widget.letterSpacing,
                  fontWeight: widget.fontWeight,
                ),
              ] else ...[
                SizedBox(
                  width: Responsive.isMobile(context) ? width - 120 : 412,
                  child: Text(
                    widget.text,
                    textAlign: widget.textAlign,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontsize,
                      letterSpacing: widget.letterSpacing,
                      fontWeight: widget.fontWeight,
                    ),
                    softWrap: true,
                    maxLines: 1,
                  ),
                ),
              ],
              if (widget.titleLeft)
                const SizedBox(
                  width: 10,
                ),
              if (widget.rightIcon != null)
                Icon(
                  widget.rightIcon,
                  color: widget.righticonColor,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//------------------------------------------- checkbox------------------------------------------?

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  const CustomCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.label,
  }) : super(key: key);

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.white, // Checkbox color when unchecked
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateColor.resolveWith((states) => Colors.white), // Checkbox fill color
              checkColor: MaterialStateColor.resolveWith((states) => Colors.blue), // Checkbox check color
            ),
          ),
          child: Checkbox(
            value: _value,
            onChanged: (value) {
              setState(() {
                _value = value!;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value!);
              }
            },
          ),
        ),
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 18,
            ),
          ),
      ],
    );
  }
}

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isSmall;
  final Function(bool) onSelected;
  final Color? selectedColor;
  final Color? bgcolor;
  final Color labelColor;

  const CustomChoiceChip({
    // super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.selectedColor = AppColors.primary,
    required this.labelColor,
    this.bgcolor = AppColors.secondary,
    this.isSmall = true,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Container(
        constraints: BoxConstraints(
          minWidth: isSmall ? 80 : double.infinity,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: labelColor,
          ),
        ),
      ),
      selected: selected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      labelPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      onSelected: onSelected,
      selectedColor: selectedColor,
      backgroundColor: bgcolor,
    );
  }
}

class CustomCheckboxListTile extends StatelessWidget {
  final void Function() onSelected;
  final bool isChecked;
  const CustomCheckboxListTile({
    // super.key,
    required this.onSelected,
    this.isChecked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: GestureDetector(
        onTap: onSelected,
        child: Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (newVal) {
                onSelected();
              },
            ),
            AppText(text: 'Use Same number for whatsapp'),
          ],
        ),
      ),
    );
  }
}

class CustomInkWell extends StatelessWidget {
  const CustomInkWell({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: child,
    );
  }
}
