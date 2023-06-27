// ignore_for_file: public_member_api_docs, constant_identifier_names

/// This is an enumeration in Dart called `RouterMeta`. It defines a set of named constants, each of
/// which has a `path` and a `name` property. The constants represent different routes in a web
/// application, such as the home page, login page, settings page, etc. The `const` keyword is used to
/// make the enumeration values immutable. The `required` keyword is used to indicate that the `path`
/// and `name` properties are mandatory and must be provided when creating a new instance of the
/// enumeration. The `final` keyword is used to make the `name` and `path` properties read-only.
enum RouterMeta {
  Home(path: '/home', title: 'Notes', name: 'home'),
  Login(path: '/login', title: 'Login to a instance', name: 'login'),
  ConnectToServer(
    path: '/connect/:url',
    title: 'Nextcloud',
    name: 'connect-to-server',
  ),
  NewNote(path: '/new-note', title: 'New Note', name: 'new-note'),
  Settings(path: '/settings', title: 'Settings', name: 'settings'),
  Categories(path: '/categories', title: 'Categories', name: 'categories'),
  SingleNote(path: '/note/:id', title: 'Note', name: 'single-note'),
  AddNewAccount(
    path: '/add-new-account',
    title: 'Add new account',
    name: 'add-new-account',
  ),
  IntroductionScreen(
    path: '/introduction-screen',
    title: 'Nixy',
    name: 'introduction-screen',
  ),
  CategoryPosts(
    path: '/category-posts/:categoryName',
    title: 'Nixy',
    name: 'category-posts',
  );

  const RouterMeta({
    required this.path,
    required this.name,
    required this.title,
  });

  /// `final String name;` is declaring a read-only property called `name` of type `String` for each value
  /// in the `RouterMeta` enumeration. This property holds the name of the route, which can be used for
  /// display purposes or for identifying the route in code. Since it is declared as `final`, its value
  /// cannot be changed once it is set during the creation of the enumeration value.
  final String name;

  /// `final String path;` is declaring a read-only property called `path` of type `String` for each value
  /// in the `RouterMeta` enumeration. This property holds the path of the route, which is the URL that
  /// corresponds to the route. Since it is declared as `final`, its value cannot be changed once it is
  /// set during the creation of the enumeration value.
  final String path;

  /// The `final String title;` line is defining a property called `title` for the `RouterMeta`
  /// enumeration, but it is not being initialized with a value. This means that any value of `RouterMeta`
  /// will have a `title` property that is `null` by default. It is possible that this property was
  /// intended to be used for something else, but it is not currently being used in the code.
  final String title;
}
