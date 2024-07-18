bool checkHexString(String value, {bool containTransparent = false}) {
  RegExp hexRegex;
  if (containTransparent) {
    hexRegex = RegExp(r'^#[0-9a-fA-F]{6,8}$');
  } else {
    hexRegex = RegExp(r'^#[0-9a-fA-F]{6}$');
  }
  return hexRegex.hasMatch(value);
}
