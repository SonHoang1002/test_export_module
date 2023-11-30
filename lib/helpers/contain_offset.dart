import 'package:flutter/material.dart';

bool containOffset(Offset checkOffset, Offset startOffset, Offset endOffset) {
  return (startOffset.dx <= checkOffset.dx && checkOffset.dx <= endOffset.dx) &&
      (startOffset.dy <= checkOffset.dy && checkOffset.dy <= endOffset.dy);
}
