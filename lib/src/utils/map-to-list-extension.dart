extension MapToListExtension on List {
List<T> mapToList<T>(T f(e)) => this.map(f).toList();
}
