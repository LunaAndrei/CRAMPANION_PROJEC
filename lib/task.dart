class Task {
  final String id;
  String Subject;
  List<String> details;
  List<DateTime> submissionDateTimes;
  List<String> additionalDetails;
  bool isDone;

  Task({
    required this.id,
    required this.Subject,
    required this.details,
    required this.submissionDateTimes,
    this.additionalDetails = const [],
    this.isDone = false,
  });

  // Convert a Task object into a Map object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Subject': Subject,
      'details': details,
      'submissionDateTimes': submissionDateTimes.map((e) => e.toIso8601String()).toList(),
      'additionalDetails': additionalDetails,
      'isDone': isDone,
    };
  }

  // Extract a Task object from a Map object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      Subject: json['Subject'],
      details: List<String>.from(json['details']),
      submissionDateTimes: List<DateTime>.from(json['submissionDateTimes'].map((e) => DateTime.parse(e))),
      additionalDetails: List<String>.from(json['additionalDetails']),
      isDone: json['isDone'],
    );
  }
}
