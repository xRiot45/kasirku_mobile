import 'package:intl/intl.dart';

String formatToRupiah(int amount){
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp.',
    decimalDigits: 0
  );

  return formatter.format(amount);
}