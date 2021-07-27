import 'dart:async';

import 'package:english_words/english_words.dart';

class Bloc{
  Set<WordPair> saved = Set<WordPair>();

  final _savedController = StreamController();
}

var bloc = Bloc();