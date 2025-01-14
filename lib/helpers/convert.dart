import 'package:flutter/material.dart';

String convertColorToHexString(Color color) {
  // Lấy các thành phần RGBA từ đối tượng `Color`
  final r = color.red.toRadixString(16).padLeft(2, '0').toUpperCase();
  final g = color.green.toRadixString(16).padLeft(2, '0').toUpperCase();
  final b = color.blue.toRadixString(16).padLeft(2, '0').toUpperCase();
  final a = color.alpha.toRadixString(16).padLeft(2, '0').toUpperCase();

  // Nếu alpha là "FF", loại bỏ alpha khỏi kết quả
  return a == "FF" ? "#$r$g$b" : "#$a$r$g$b";
}

/// Chuyển đổi chuỗi HEX thành `Color`
/// Chuỗi [value] có định dạng: #RRGGBB, RRGGBB, #AARRGGBB hoặc AARRGGBB
Color convertHexStringToColor(String value) {
  try {
    // Loại bỏ ký tự '#' nếu tồn tại
    final normalizedValue = value.startsWith("#") ? value.substring(1) : value;

    // Xác định nếu chỉ có RRGGBB thì thêm "FF" (alpha mặc định)
    final hasAlpha = normalizedValue.length == 8;
    final hexColor = hasAlpha ? normalizedValue : "FF$normalizedValue";

    // Phân tích chuỗi thành số nguyên
    return Color(int.parse("0x$hexColor"));
  } catch (e) {
    // Xử lý lỗi và trả về giá trị mặc định
    return Colors.transparent;
  }
}
