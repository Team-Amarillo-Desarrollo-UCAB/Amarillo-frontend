class NotificationData {
  final String title;
  final String body;
  final String id;
  final DateTime date;
  final bool userReaded;

  NotificationData({
    required this.title,
    required this.body,
    required this.id,
    required this.date,
    required this.userReaded,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'],
      body: json['body'],
      id: json['id'],
      date: DateTime.parse(json['date']),
      userReaded: json['userReaded'],
    );
  }
}
