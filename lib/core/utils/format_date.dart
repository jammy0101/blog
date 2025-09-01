
import 'package:intl/intl.dart';

String formatDataBydMMMYYYY(DateTime dateTime){
  return DateFormat("d,MMM,yyyy").format(dateTime);
}