class LogItem {
  String type = 'default';
  String value;

  LogItem(String value, { type: '#' }) {
    this.type = type;
    this.value = value;
  }
}
