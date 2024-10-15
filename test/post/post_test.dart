import 'package:brainshare/model/post.dart';
import 'package:brainshare/services/user_content/post_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'post_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PostService>(), MockSpec<Post>()])

void main() {
  group("Post Service", () {
    late MockPostService postService;

    setUp(() {
      postService = MockPostService();
    });

    test("Add Post", () async {
      Post testPost = Post("mockUser", "post", "Maths");
      when(postService.addPost(any)).thenAnswer((_) async => {});

      await postService.addPost(testPost);

      verify(postService.addPost(testPost)).called(1);
    });

    test("Fetch Posts", () async {
      when(postService.getItems()).thenAnswer((_) async => [Post("mockUser", "post", "Maths")]);

      var posts = await postService.getItems();

      expect(posts, isA<List<Post>>());
      expect(posts.first.author, equals("mockUser"));
      expect(posts.first.text, equals("post"));

      verify(postService.getItems()).called(1);
    });
    
    test("Fetch Posts from user", () async {
      when(postService.fetchPostsFrom("mockUser")).thenAnswer((_) async => {});
      when(postService.getItems()).thenAnswer((_) async => [Post("mockUser", "post", "Maths")]);

      await postService.fetchPostsFrom("mockUser");
      var posts = await postService.getItems();

      expect(posts, isA<List<Post>>());
      expect(posts.first.author, equals("mockUser"));
      expect(posts.first.text, equals("post"));

      verify(postService.getItems()).called(1);
      verify(postService.fetchPostsFrom("mockUser")).called(1);
    });

    test("Fetch Posts by category", () async {
      when(postService.fetchPostsByCategory("Maths")).thenAnswer((_) async => {});
      when(postService.getItems()).thenAnswer((_) async => [Post("mockUser", "post", "Maths")]);

      await postService.fetchPostsByCategory("Maths");
      var posts = await postService.getItems();

      expect(posts, isA<List<Post>>());
      expect(posts.first.author, equals("mockUser"));
      expect(posts.first.text, equals("post"));
      expect(posts.first.category, "Maths");

      verify(postService.getItems()).called(1);
      verify(postService.fetchPostsByCategory("Maths")).called(1);
    });
  });
}