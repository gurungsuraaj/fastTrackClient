class PrimaryKeyGenerator {
  static int generateKey() {

    int key = new DateTime.now().millisecondsSinceEpoch;
    return key;
  }
}