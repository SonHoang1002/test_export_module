  bool isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }