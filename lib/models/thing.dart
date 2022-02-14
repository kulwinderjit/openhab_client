class Thing {
  Thing();
  String? name;
  String? uuid;
  bool? state;

  Thing.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uuid = json['uuid'],
        state = json['state'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'uuid': uuid,
        'state': state,
      };
}
