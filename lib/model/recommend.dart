part 'recommend.g.dart';

enum RecommendOperation {
  count,
  canLocate;

  String toJson() {
    switch (this) {
      case RecommendOperation.count:
        return 'count';
      case RecommendOperation.canLocate:
        return 'can_locate';
    }
  }
}

class RecommendOperationResult {
  final dynamic result;

  RecommendOperationResult(this.result);

  factory RecommendOperationResult.fromJson(Map<String, dynamic> json) {
    if (json['count'] != null) {
      return RecommendOperationResult(CountResult.fromJson(json));
    } else if (json['can_locate'] != null) {
      return RecommendOperationResult(CanLocateResult.fromJson(json));
    } else {
      throw Exception("Unknown operation result type: $json");
    }
  }
}

class CountResult {
  final int count;

  CountResult(this.count);

  factory CountResult.fromJson(Map<String, dynamic> json) {
    return CountResult(json['count']);
  }
}

class CanLocateResult {
  final bool canLocate;

  CanLocateResult(this.canLocate);

  factory CanLocateResult.fromJson(Map<String, dynamic> json) {
    return CanLocateResult(json['can_locate']);
  }
}
