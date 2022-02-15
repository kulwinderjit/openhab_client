class Rule {
  Rule();
  String? name;
  String? uuid;
  bool? state;
  String? description;

  Rule.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uuid = json['uuid'],
        state = json['state'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'uuid': uuid,
        'state': state,
        'description': description,
      };
}
