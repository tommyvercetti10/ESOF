import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:brainshare/model/comment.dart';
import 'package:brainshare/services/user_content/comment_service.dart';
import 'comment_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Comment>(), MockSpec<CommentService>()])

void main() {
  group("Comment Service", () {
    late MockCommentService commentService;

    setUp(() {
      commentService = MockCommentService();
    });

    test("Add comment", () async {
      Comment testComment = Comment("mockUser", "very nice", 4, "mockReceiver", false);
      when(commentService.addComment(any)).thenAnswer((_) async => {});

      await commentService.addComment(testComment);

      verify(commentService.addComment(testComment)).called(1);
    });

    test("Fetch comments", () async {
      when(commentService.fetchCommentsFrom("mockUser", true)).thenAnswer((_) {
            return Future.value();
      });
      when(commentService.comments).thenReturn([Comment("mockUser", "very nice", 4, "mockReceiver", true)]);
      await commentService.fetchCommentsFrom("mockUser", true);
      var comments = commentService.comments;

      expect(comments, isA<List<Comment>>());
      expect(comments.first.author, equals("mockUser"));
      expect(comments.first.text, equals("very nice"));
      expect(comments.first.rating, equals(4));
      expect(comments.first.receiverUid, equals("mockReceiver"));

      verify(commentService.fetchCommentsFrom("mockUser", true)).called(1);
    });
  });
}