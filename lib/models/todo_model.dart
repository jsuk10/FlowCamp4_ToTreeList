class Todo {
   dynamic id;
   dynamic name;
   dynamic date;
   dynamic state;

  Todo({required this.id, required this.name, required this.date, required this.state});

  @override
  toString() => name;
}