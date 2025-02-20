// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:implementation_imports, file_names, unnecessary_new
// ignore_for_file:unnecessary_brace_in_string_interps, directives_ordering
// ignore_for_file:argument_type_not_assignable, invalid_assignment
// ignore_for_file:prefer_single_quotes, prefer_generic_function_type_aliases
// ignore_for_file:comment_references

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_ar.dart' as messages_ar;
import 'messages_bn.dart' as messages_bn;
import 'messages_en.dart' as messages_en;
import 'messages_hi.dart' as messages_hi;
import 'messages_id.dart' as messages_id;
import 'messages_ko.dart' as messages_ko;
import 'messages_pt.dart' as messages_pt;
import 'messages_sw.dart' as messages_sw;
import 'messages_ta.dart' as messages_ta;
import 'messages_th.dart' as messages_th;
import 'messages_ur.dart' as messages_ur;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'ar': () => new Future.value(null),
  'bn': () => new Future.value(null),
  'en': () => new Future.value(null),
  'hi': () => new Future.value(null),
  'id': () => new Future.value(null),
  'ko': () => new Future.value(null),
  'pt': () => new Future.value(null),
  'sw': () => new Future.value(null),
  'ta': () => new Future.value(null),
  'th': () => new Future.value(null),
  'ur': () => new Future.value(null),
};

MessageLookupByLibrary? _findExact(String localeName) {
  switch (localeName) {
    case 'ar':
      return messages_ar.messages;
    case 'bn':
      return messages_bn.messages;
    case 'en':
      return messages_en.messages;
    case 'hi':
      return messages_hi.messages;
    case 'id':
      return messages_id.messages;
    case 'ko':
      return messages_ko.messages;
    case 'pt':
      return messages_pt.messages;
    case 'sw':
      return messages_sw.messages;
    case 'ta':
      return messages_ta.messages;
    case 'th':
      return messages_th.messages;
    case 'ur':
      return messages_ur.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName, (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return new Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? new Future.value(false) : lib());
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
  var actualLocale =
      Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
