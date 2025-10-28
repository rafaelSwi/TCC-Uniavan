import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

var _cpfFormatter = new MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

var _cepFormatter = new MaskTextInputFormatter(
  mask: '####-####',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

class MegaObraFieldCpf extends StatelessWidget {
  final TextEditingController controller;
  const MegaObraFieldCpf({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 14,
      controller: controller,
      inputFormatters: [_cpfFormatter],
      style: TextStyle(
        color: megaobraNeutralText(),
      ),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.cpf.toUpperCase(),
        labelStyle: TextStyle(color: megaobraNeutralText()),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
      ),
      keyboardType: TextInputType.number,
      obscureText: false,
    );
  }
}

class MegaObraFieldCep extends StatelessWidget {
  final TextEditingController controller;
  const MegaObraFieldCep({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 9,
      controller: controller,
      inputFormatters: [_cepFormatter],
      style: TextStyle(
        color: megaobraNeutralText(),
      ),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.cep.toUpperCase(),
        labelStyle: TextStyle(color: megaobraNeutralText()),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
      ),
      keyboardType: TextInputType.number,
      obscureText: false,
    );
  }
}

class MegaObraFieldNumerical extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLength;
  final bool allowDecimal;

  const MegaObraFieldNumerical({
    super.key,
    required this.controller,
    this.label = "",
    this.maxLength = 4,
    this.allowDecimal = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatter =
        allowDecimal ? FilteringTextInputFormatter.allow(RegExp(r'^\d+[,]?\d{0,2}')) : FilteringTextInputFormatter.digitsOnly;

    return TextField(
      maxLength: maxLength,
      controller: controller,
      inputFormatters: [formatter],
      style: TextStyle(
        color: megaobraNeutralText(),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: megaobraNeutralText()),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimal,
        signed: false,
      ),
      obscureText: false,
    );
  }
}

class MegaObraFieldPassword extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  const MegaObraFieldPassword({
    super.key,
    required this.controller,
    this.obscureText = true,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 32,
      controller: controller,
      style: TextStyle(
        color: megaobraNeutralText(),
      ),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.password,
        labelStyle: TextStyle(color: megaobraNeutralText()),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
      ),
      keyboardType: TextInputType.text,
      obscureText: obscureText,
    );
  }
}

class MegaObraFieldName extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool allowNumbers;
  final int maxLength;
  const MegaObraFieldName({
    super.key,
    required this.controller,
    this.label = "",
    this.allowNumbers = false,
    this.maxLength = 128,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      controller: controller,
      style: TextStyle(
        color: megaobraNeutralText(),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: megaobraNeutralText()),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: megaobraNeutralText()),
        ),
      ),
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(
          allowNumbers ? r'[!@#$%^&*(),?":{}|<>]' : r'[0-9!@#$%^&*(),.?":{}|<>]',
        )),
      ],
    );
  }
}
