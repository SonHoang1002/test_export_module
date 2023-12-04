bool checkHexString(String value) {
  final hexRegex = RegExp(r'^#[0-9a-fA-F]{6}$');
  return hexRegex.hasMatch(value);
}