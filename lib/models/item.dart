class Item {
  Item({
    required this.type,
    required this.name,
    required this.label,
    required this.link,
    required this.state,
    required this.groupName,
  });
  late final String type;
  late final String name;
  late final String label;
  late final String groupName;
  late final String link;
  String state;

  Item.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        name = json['name'],
        label = json['label'],
        groupName = json['groupName'],
        link = json['link'],
        state = json['state'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'label': label,
        'groupName': groupName,
        'link': link,
        'state': state
      };
}
