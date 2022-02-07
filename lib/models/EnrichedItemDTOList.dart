import 'package:json_annotation/json_annotation.dart';
import 'package:openhab_client/models/EnrichedItemDTO.dart';

part 'EnrichedItemDTOList.g.dart';

@JsonSerializable(explicitToJson: true)
class EnrichedItemDTOList {
  EnrichedItemDTOList({this.items});

  List<EnrichedItemDTO>? items;
  factory EnrichedItemDTOList.fromJson(Map<String, dynamic> json) =>
      _$EnrichedItemDTOListFromJson(json);
  Map<String, dynamic> toJson() => _$EnrichedItemDTOListToJson(this);
}
