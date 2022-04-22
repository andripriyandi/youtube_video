class Tupple<HandleFailure, ResponseObject> {
  HandleFailure? handleFailure;
  ResponseObject? onSuccess;

  Tupple({this.handleFailure, this.onSuccess});
}
