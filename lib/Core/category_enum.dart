enum CategoryType {
  length('length'),
  weight('weight'),
  temperature('temperature'),
  time('time'),
  volume('volume'),
  energy('energy'),
  frequency('frequency'),
  power('power'),
  pressure('pressure'),
  speed('speed'),
  data('data'),
  currency('currency');

  final String name;

  const CategoryType(this.name);
}
