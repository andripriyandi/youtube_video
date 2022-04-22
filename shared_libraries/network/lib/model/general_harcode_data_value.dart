import 'dart:convert';

class ListGeneralHardCodeDataValue {
  List<GeneralHardCodeDataValue> data;
  ListGeneralHardCodeDataValue({
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory ListGeneralHardCodeDataValue.fromMap(Map<String, dynamic> map) {
    return ListGeneralHardCodeDataValue(
      data: List<GeneralHardCodeDataValue>.from(
          map['data']?.map((x) => GeneralHardCodeDataValue.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListGeneralHardCodeDataValue.fromJson(String source) =>
      ListGeneralHardCodeDataValue.fromMap(json.decode(source));
}

class GeneralHardCodeDataValue {
  String id;
  String text;
  GeneralHardCodeDataValue({
    required this.id,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }

  factory GeneralHardCodeDataValue.fromMap(Map<String, dynamic> map) {
    return GeneralHardCodeDataValue(
      id: map['id'] ?? "",
      text: map['text'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory GeneralHardCodeDataValue.fromJson(String source) =>
      GeneralHardCodeDataValue.fromMap(json.decode(source));
}
