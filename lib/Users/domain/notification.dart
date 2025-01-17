class NotificationDomain {
  final String title;
  final String body;
  final String id;
  final DateTime date;
  final bool userReaded;

  NotificationDomain({
    required this.title,
    required this.body,
    required this.id,
    required this.date,
    required this.userReaded,
  });

}
