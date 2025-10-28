import 'package:intl/intl.dart';

String formatStringByLength(String description, int size) {
  if (description.length > size) {
    return "${description.substring(0, size).trim()}...";
  }
  return description;
}

String formatCPF(String cpf) {
  if (cpf.length != 11) {
    throw const FormatException('CPF must be 11 digits long');
  }
  return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
}

String formatCEP(String cep) {
  if (cep.length != 8) {
    throw const FormatException('CEP must be 8 digits long');
  }
  return '${cep.substring(0, 4)}-${cep.substring(4, 8)}';
}

String formatDateTime({DateTime? dateTime, String nullText = "00.00.00"}) {
  if (dateTime != null) {
    if (DateTime.now().year == dateTime.year) {
      return DateFormat('dd.MM.yy').format(dateTime);
    } else {
      return DateFormat('dd.MM.yy').format(dateTime);
    }
  } else {
    return nullText;
  }
}
