class DateTimeUtils {
  static List<String> meses = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];

  DateTime? parseDate(String dateString) {
    try {
      List<String> dateParts = dateString.split('/');
      if (dateParts.length != 3) {
        print('The date format should be DD/MM/YYYY');
        return null;
      }
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      // If an error occurs, print an error message and return null
      print('Error parsing date: $e');
      return null;
    }
  }

}