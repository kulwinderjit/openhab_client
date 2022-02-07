import 'package:json_annotation/json_annotation.dart';
import 'package:openhab_client/models/CommandDescription.dart';
import 'package:openhab_client/models/StateDescription.dart';
part 'EnrichedItemDTO.g.dart';

@JsonSerializable(explicitToJson: true)
class EnrichedItemDTO {
  EnrichedItemDTO(
      {this.type,
      this.name,
      this.label,
      this.category,
      this.tags,
      this.groupNames,
      this.link,
      this.state,
      this.transformedState,
      this.stateDescription,
      this.commandDescription,
      this.metadata,
      this.editable});
  String? type;
  String? name;
  String? label;
  String? category;
  Set<String>? tags;
  Set<String>? groupNames;
  String? link;
  String? state;
  String? transformedState;
  StateDescription? stateDescription;
  CommandDescription? commandDescription;
  dynamic metadata;
  bool? editable;
  factory EnrichedItemDTO.fromJson(Map<String, dynamic> json) =>
      _$EnrichedItemDTOFromJson(json);
  Map<String, dynamic> toJson() => _$EnrichedItemDTOToJson(this);
}
