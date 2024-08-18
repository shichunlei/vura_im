class BaseBean<T> {
  int code;
  String? message;
  T? data;
  List<T?> items;

  BaseBean({this.code = 0, this.message, this.data, this.items = const []});

  factory BaseBean.fromJson(Map<String, dynamic> json) {
    return BaseBean(code: json["code"] ?? 200, message: json["message"]);
  }

  factory BaseBean.fromJsonToObject(Map<String, dynamic> json) {
    return BaseBean(
        code: json["code"] ?? 200,
        message: json["message"],
        data: json['data'] == null || (json['data'] is Map) && json['data'].isEmpty ? null : json['data']);
  }

  factory BaseBean.fromJsonToList(Map<String, dynamic> json) {
    return BaseBean(
        code: json["code"],
        message: json["message"],
        items: json['data'] == null || json['data'].isEmpty ? [] : json['data']);
  }

  Map<String, dynamic> toJson() {
    return {"code": code, "message": message, "data": data, "items": items};
  }
}
