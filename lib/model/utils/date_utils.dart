import 'package:cloud_firestore/cloud_firestore.dart';

class DateUtils {
  static String getDeltaTime(Timestamp timestamp) {
    DateTime commentDate = timestamp.toDate();
    Duration difference = DateTime.now().difference(commentDate);


    if (difference.inMinutes < 60) {
      if (difference.inMinutes == 0) {
        return 'Just now!';
      } else {
        return '${difference.inMinutes} min';
      }
    } else if (difference.inDays == 0) {
      return '${difference.inHours} h';
    } else {
      return difference.inDays == 1 ? '1 day' : '${difference.inDays} days';
    }
  }
}
