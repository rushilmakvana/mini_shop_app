class httpException implements Exception {
  final String msg;

  httpException(this.msg);

  @override
  String toString() {
    return msg;
    // TODO: implement toString
    // return super.toString();
  }
}
