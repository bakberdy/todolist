class Quote {
  final String q;
  final String a;
  final String c;
  final String h;

  Quote({
    required this.q,
    required this.a,
    required this.c,
    required this.h,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      q: json['q'] as String,
      a: json['a'] as String,
      c: json['c'] as String,
      h: json['h'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'q': q,
      'a': a,
      'c': c,
      'h': h,
    };
  }
}
