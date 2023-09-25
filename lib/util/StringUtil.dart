class StringUtil {
  // 纯数字
  static final String DIGIT_REGEX = "[0-9]+";

  // 含有数字
  static final String CONTAIN_DIGIT_REGEX = ".*[0-9].*";

  // 纯字母
  static final String LETTER_REGEX = "[a-zA-Z]+";

  // 包含字母
  static final String SMALL_CONTAIN_LETTER_REGEX = ".*[a-z].*";

  // 包含字母
  static final String BIG_CONTAIN_LETTER_REGEX = ".*[A-Z].*";

  // 包含字母
  static final String CONTAIN_LETTER_REGEX = ".*[a-zA-Z].*";

  // 纯中文
  static final String CHINESE_REGEX = "[\u4e00-\u9fa5]";

  // 仅仅包含字母和数字
  static final String LETTER_DIGIT_REGEX = "^[a-z0-9A-Z]+\$";
  static final String CHINESE_LETTER_REGEX = "([\u4e00-\u9fa5]+|[a-zA-Z]+)";
  static final String CHINESE_LETTER_DIGIT_REGEX =
      "^[a-z0-9A-Z\u4e00-\u9fa5]+\$";

  // 邮箱判断
  static bool isEmail(String input) {
    String regexEmail =
        "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

  // 纯数字
  static bool isOnly(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(DIGIT_REGEX).hasMatch(input);
  }

  // 含有数字
  static bool hasDigit(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(CONTAIN_DIGIT_REGEX).hasMatch(input);
  }

  // 是否包含中文
  static bool isChinese(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(CHINESE_REGEX).hasMatch(input);
  }
}
