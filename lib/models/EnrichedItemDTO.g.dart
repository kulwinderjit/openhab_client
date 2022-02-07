// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EnrichedItemDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrichedItemDTO _$EnrichedItemDTOFromJson(Map<String, dynamic> json) =>
    EnrichedItemDTO(
      type: json['type'] as String?,
      name: json['name'] as String?,
      label: json['label'] as String?,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toSet(),
      groupNames: (json['groupNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toSet(),
      link: json['link'] as String?,
      state: json['state'] as String?,
      transformedState: json['transformedState'] as String?,
      stateDescription: json['stateDescription'] == null
          ? null
          : StateDescription.fromJson(
              json['stateDescription'] as Map<String, dynamic>),
      commandDescription: json['commandDescription'] == null
          ? null
          : CommandDescription.fromJson(
              json['commandDescription'] as Map<String, dynamic>),
      metadata: json['metadata'],
      editable: json['editable'] as bool?,
    );

Map<String, dynamic> _$EnrichedItemDTOToJson(EnrichedItemDTO instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'label': instance.label,
      'category': instance.category,
      'tags': instance.tags?.toList(),
      'groupNames': instance.groupNames?.toList(),
      'link': instance.link,
      'state': instance.state,
      'transformedState': instance.transformedState,
      'stateDescription': instance.stateDescription?.toJson(),
      'commandDescription': instance.commandDescription?.toJson(),
      'metadata': instance.metadata,
      'editable': instance.editable,
    };
