class ApiEndpoint {
  static String baseUrl = 'absensi.picodio.co.id';
  static String prefix = 'api';

  static String getAchievements = '$prefix/user/achievement';
  static String createAchievements = '$prefix/user/achievement/create';
  static String updateAchievements = '$prefix/user/achievement/update';
  static String deleteAchievements = '$prefix/user/achievement/destroy';
}
