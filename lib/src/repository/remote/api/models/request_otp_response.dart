class RequestOtpResponse {
  final int timeToNext;

  RequestOtpResponse(this.timeToNext);

  factory RequestOtpResponse.fromJson(Map<String, dynamic> json) {
    return RequestOtpResponse(json['time_to_next'] as int);
  }
}