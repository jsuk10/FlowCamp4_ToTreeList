class Todo {
  dynamic id;
  dynamic name;
  dynamic date;
  dynamic state;


  Todo(
      {this.id,
      required this.name,
      required this.date,
      this.state = 0});

  @override
  toString() => name;
}
