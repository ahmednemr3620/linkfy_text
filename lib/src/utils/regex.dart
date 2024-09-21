import 'package:linkfy_text/src/enum.dart';

// String urlRegExp =

///Regular Expression values taken from https://github.com/santa112358/detectable_text_field

const _symbols = '·・ー_';

const _numbers = '0-9０-９';

const _englishLetters = 'a-zA-Zａ-ｚＡ-Ｚ';

const _japaneseLetters = 'ぁ-んァ-ン一-龠';

const _koreanLetters = '\u1100-\u11FF\uAC00-\uD7A3';

const _spanishLetters = 'áàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ';

const _arabicLetters = '\u0621-\u064A';

const _thaiLetters = '\u0E00-\u0E7F';

const _turkishLetters = 'ğüşıöçĞÜŞİÖÇ';

const _vietnameseLetters =
    'AĂÂÁẮẤÀẰẦẢẲẨÃẴẪẠẶẬĐEÊÉẾÈỀẺỂẼỄẸỆIÍÌỈĨỊOÔƠÓỐỚÒỒỜỎỔỞÕỖỠỌỘỢUƯÚỨÙỪỦỬŨỮỤỰYÝỲỶỸỴAĂÂÁẮẤÀẰẦẢẲẨÃẴẪẠẶẬĐEÊÉẾÈỀẺỂẼỄẸỆIÍÌỈĨỊOÔƠÓỐỚÒỒỜỎỔỞÕỖỠỌỘỢUƯÚỨÙỪỦỬŨỮỤỰYÝỲỶỸỴAĂÂÁẮẤÀẰẦẢẲẨÃẴẪẠẶẬĐEÊÉẾÈỀẺỂẼỄẸỆIÍÌỈĨỊOÔƠÓỐỚÒỒỜỎỔỞÕỖỠỌỘỢUƯÚỨÙỪỦỬŨỮỤỰYÝỲỶỸỴAĂÂÁẮẤÀẰẦẢẲẨÃẴẪẠẶẬĐEÊÉẾÈỀẺỂẼỄẸỆIÍÌỈĨỊOÔƠÓỐỚÒỒỜỎỔỞÕỖỠỌỘỢUƯÚỨÙỪỦỬŨỮỤỰYÝỲỶỸỴAĂÂÁẮẤÀẰẦẢẲẨÃẴẪẠẶẬĐEÊÉẾÈỀẺỂẼỄẸỆIÍÌỈĨỊOÔƠÓỐỚÒỒỜỎỔỞÕỖỠỌỘỢUƯÚỨÙỪỦỬŨỮỤỰYÝỲỶỸỴAĂÂÁẮẤÀẰẦẢẲẨÃẴẪẠẶẬĐEÊÉẾÈỀẺỂẼỄẸỆIÍÌỈĨỊOÔƠÓỐỚÒỒỜỎỔỞÕỖỠỌỘỢUƯÚỨÙỪỦỬŨỮỤỰYÝỲỶỸỴ';
final _vietnameseLettersLowerCase = _vietnameseLetters.toLowerCase();

const _persianLetters = "\u0600-\u06FF";

final detectionContentLetters = _symbols +
    _numbers +
    _englishLetters +
    _japaneseLetters +
    _koreanLetters +
    _spanishLetters +
    _arabicLetters +
    _thaiLetters +
    _vietnameseLetters +
    _vietnameseLettersLowerCase +
    _persianLetters +
    _turkishLetters;

// const urlRegexContent = "((http|https)://)(www.)?" +
//     "[a-zA-Z0-9@:%._\\+~#?&//=]" +
//     "{2,256}\\.[a-z]" +
//     "{2,6}\\b([-a-zA-Z0-9@:%" +
//     "._\\+~#?&//=]*)";

// Thanks to @Bhupesh-V for contribution.
const urlRegexContent = "((http|https)://)(www.)?" +
    "[a-zA-Z0-9@:%._\\+~#?&//=-]" +
    "{2,256}\\.[a-z]" +
    "{2,6}\\b([-a-zA-Z0-9@:%" +
    "._\\+~#?&//=]*)";

/// Regular expression to extract hashtag
///
/// Supports English, Japanese, Korean, Spanish, Arabic, and Thai
final hashTagReg = RegExp(
  "(?!\\n)(?:^|\\s)(#([$detectionContentLetters]+))",
  multiLine: true,
);

final atSignRegExp = RegExp(
  "(?!\\n)(?:^|\\s)([@]([$detectionContentLetters]+))",
  multiLine: true,
);

final urlRegex = RegExp(
  urlRegexContent,
  multiLine: true,
);

final emojiRegex = RegExp(
  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
);



// url regex that accept https, http, www
String urlRegExp =
    r'((https?://)?(www\.)?[a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*))';

String hashtagRegExp = hashTagReg.pattern;

String userTagRegExp = r'(?<![\w@])@([\w@]+(?:[.!][\w@]+)*)';
String phoneRegExp =
    r'\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*';
String emailRegExp =
    r"([a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+)";

/// construct regexp. pattern from provided link types
RegExp constructRegExpFromLinkType(List<LinkType> types) {
  // default case where we always want to match url strings
  final len = types.length;
  if (len == 1 && types.first == LinkType.url) {
    return RegExp(urlRegExp);
  }
  final buffer = StringBuffer();
  for (var i = 0; i < len; i++) {
    final type = types[i];
    final isLast = i == len - 1;
    switch (type) {
      case LinkType.url:
        isLast ? buffer.write("($urlRegExp)") : buffer.write("($urlRegExp)|");
        break;
      case LinkType.hashTag:
        isLast
            ? buffer.write("($hashtagRegExp)")
            : buffer.write("($hashtagRegExp)|");
        break;
      case LinkType.userTag:
        isLast
            ? buffer.write("($userTagRegExp)")
            : buffer.write("($userTagRegExp)|");
        break;
      case LinkType.email:
        isLast
            ? buffer.write("($emailRegExp)")
            : buffer.write("($emailRegExp)|");
        break;
      case LinkType.phone:
        isLast
            ? buffer.write("($phoneRegExp)")
            : buffer.write("($phoneRegExp)|");
        break;
      default:
    }
  }
  return RegExp(buffer.toString());
}

LinkType getMatchedType(String match) {
  late LinkType type;
  if (RegExp(emailRegExp).hasMatch(match)) {
    type = LinkType.email;
  } else if (RegExp(phoneRegExp).hasMatch(match)) {
    type = LinkType.phone;
  } else if (RegExp(userTagRegExp).hasMatch(match)) {
    type = LinkType.userTag;
  } else if (RegExp(urlRegExp).hasMatch(match)) {
    type = LinkType.url;
  } else if (hashTagReg.hasMatch(match)) {
    type = LinkType.hashTag;
  }
  return type;
}
