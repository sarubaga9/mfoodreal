import 'package:intl/intl.dart';

class FormatMethod {
  ConvertToThaiBath(var number) {
    var n;
    if (number >= 10000.00 && number < 100000.00) {
      n = (number / 10000.00).toStringAsFixed(1);
      return [n, 'หมื่นบาท'];
    } else if (number >= 100000.00 && number < 1000000.00) {
      n = (number / 100000.00).toStringAsFixed(1);
      return [n, 'แสนบาท'];
    } else if (number >= 1000000.00) {
      n = (number / 1000000.00).toStringAsFixed(1);
      return [n, 'ล้านบาท'];
    } else if (number >= 10000000.00) {
      n = (number / 10000000.00).toStringAsFixed(1);
      return [n, 'สิบล้านบาท'];
    } else if (number >= 100000000.00) {
      n = (number / 100000000.00).toStringAsFixed(1);
      return [n, 'ร้อยล้านบาท'];
    } else if (number >= 1000000000.00) {
      n = (number / 1000000000.00).toStringAsFixed(1);
      return [n, 'พันล้านบาท'];
    } else if (number >= 10000000000.00) {
      n = (number / 10000000000.00).toStringAsFixed(1);
      return [n, 'ล้านล้านบาท'];
    } else {
      return [number.toString(), 'บาท'];
    }
  }

  SeperateNumber(var number) {
    if (number.runtimeType == double) {
      number = number.toStringAsFixed(2);
    }
    var n = number.toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String result = n.replaceAllMapped(reg, (Match match) => '${match[1]},');
    return result;
  }

  DateFormat(DateTime date) {
    var d = date.day;
    var y = date.year;
    var m = date.month;
    return '$y-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
  }

  DateTimeFormat(var date) {
    return date.toString().split('.')[0];
  }

  PadLeft(var str) {
    var StrString;
    if (str.runtimeType != String) {
      StrString = str.toString();
    } else {
      StrString = str;
    }
    return StrString.padLeft(2, '0');
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null ? true : false;
  }

  ThaiFormat(String date) {
    List month = [null, 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    var tmp = date.split('-');

    /// Thai Date Format 01 พ.ย. 2563
    return '${'${tmp[2]} ' + month[int.parse(tmp[1])]} ${int.parse(tmp[0]) + 543}';
  }

  ThaiDateFormat(String date) {
    var listDate = date.split('-');
    var now = DateTime(int.parse(listDate[0].toString()), int.parse(listDate[1].toString()), int.parse(listDate[2].toString()));
    var thaiMonth = [null, 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    var result = '${now.day}/${thaiMonth[now.month]}/${now.year + 543}';
    return result;
  }

  ThaiMonthFormat(String date) {
    var listDate = date.split('-');
    var now = DateTime(int.parse(listDate[0].toString()), int.parse(listDate[1].toString()), int.parse(listDate[2].toString()));
    var thaiMonth = [null, 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    var result = '${thaiMonth[now.month]} ${now.year + 543}';
    return result;
  }

  ThaiDateTimeFormat(String date) {
    // print(date);
    if (date != '') {
      var listDate = date.split('-');
      // var now = new DateTime(int.parse(listDate[0].toString()),
      //     int.parse(listDate[1].toString()), int.parse(listDate[2].toString()));
      var now = DateTime.parse(date);
      var thaiMonth = [null, 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
      var result = '${now.day} ${thaiMonth[now.month]} ${now.year + 543} เวลา ${now.hour}:${now.minute} น.';
      return result;
    }
    return '';
  }

  ThaiDateFormatFromDateTime(DateTime date) {
    var now = date;
    var thaiMonth = [null, 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    var result = '${now.day} ${thaiMonth[now.month]} ${now.year + 543}';
    return result;
  }

  DateFormatFromDateTime(DateTime date) {
    var now = date;
    var thaiMonth = [null, 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    var result = '${now.day} ${thaiMonth[now.month]} ${now.year}';
    return result;
  }


  chkNum(var val) {
    if (val.runtimeType == String) {
      if (isNumeric(val) == false) {
        return 0;
      }
      if (val.includes('.')) {
        return double.parse(val);
      } else {
        return int.parse(val);
      }
    } else {
      return val;
    }
  }

  int chkNumResInt(var val) {
    if (val.runtimeType == String) {
      if (isNumeric(val) == false) {
        return 0;
      }

      if (val.contains(".")) {
        return int.parse(val);
      } else {
        return int.parse(val);
      }
    } else if (val.runtimeType == double) {
      return val.toInt();
    } else if (val == null) {
      return 0;
    } else {
      return val;
    }
  }

  double chkNumResDouble(var val) {
    if (val.runtimeType == String) {
      if (isNumeric(val) == false) {
        return 0.0;
      }

      if (val.contains(".")) {
        return double.parse(val);
      } else {
        return double.parse(val);
      }
    } else if (val.runtimeType == int) {
      return val.toDouble();
    } else if (val == null) {
      return 0.0;
    } else {
      return val;
    }
  }

  convertToString(var val) {
    if (val.runtimeType == String) {
      return val;
    } else {
      return val.toString();
    }
  }

  stringToNumber(String val) {
    if (val.runtimeType == String) {
      var res = int.tryParse(val) ?? double.tryParse(val);
      if (res != null) {
        return res;
      } else {
        return 0;
      }
    } else {
      return val;
    }
  }

  convertToTan(String val) {
    var res = int.tryParse(val) ?? double.tryParse(val);
    if (res != null) {
      double res2 = (res * 50) / 1000;
      if (res2 == 0.5) {
        return 'ครึ่งตัน';
      }
      if (res2 == 2.5) {
        return '2 ตันครึ่ง';
      }
      return "${((res * 50) / 1000).toInt()} ตัน";
    } else {
      return "0 ตัน";
    }
  }

  addComma(String val) {
    // add comma
    var res = int.tryParse(val) ?? double.tryParse(val);
    if (res != null) {
      res = res.toInt();
      return NumberFormat("#,###").format(res);
    } else {
      return "0";
    }
  }

  commaAndChkNum(var number) {
    number = chkNumResInt(number);
    if (number.runtimeType == double) {
      number = number.toStringAsFixed(2);
    }
    var n = number.toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String result = n.replaceAllMapped(reg, (Match match) => '${match[1]},');
    return result;
  }

  checkStrNull(var str){
    if(str == null){
      return '';
    }else if(str == 'null'){
      return '';
    }else{
      return str;
    }
  }


}
