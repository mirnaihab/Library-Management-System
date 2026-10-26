enum Category {
  fiction('Fiction'),
  science('Science'),
  history('History'),
  technology('Technology'),
  children('Children');

  const Category(this.displayName);

  final String displayName;
}
