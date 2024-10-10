class AsyncResponse<T> {
  AsyncResponse({this.data, this.exception});

  T? data;
  Exception? exception;

  bool get hasData => data != null;
  bool get hasException => exception != null;

  bool isRight() {
    return hasData;
  }
}
