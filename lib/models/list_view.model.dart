// ignore_for_file: public_member_api_docs, sort_constructors_first

/// This code is defining an enumeration type called `HomeListView` with two possible values: `grid` and
/// `list`. This enumeration can be used to represent different views for a home screen, such as a grid
/// view or a list view.
enum HomeListView {
  grid(title: 'Grid with preview'),
  list(title: 'List with basic information');

  final String title;
  const HomeListView({required this.title});
}
