// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EnrichedItemDTOList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrichedItemDTOList _$EnrichedItemDTOListFromJson(Map<String, dynamic> json) =>
    EnrichedItemDTOList(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => EnrichedItemDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EnrichedItemDTOListToJson(
        EnrichedItemDTOList instance) =>
    <String, dynamic>{
      'items': instance.items?.map((e) => e.toJson()).toList(),
    };
