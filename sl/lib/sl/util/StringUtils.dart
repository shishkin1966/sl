class StringUtils {
  static bool isNullOrEmpty(String value) {
    if (value == null) return true;
    if (value.trim().length == 0) return true;
    return false;
  }
}
