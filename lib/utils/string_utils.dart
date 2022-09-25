class StringUtils {
  static String getImgUrl(String id, String size) {
    return 'https://restaurant-api.dicoding.dev/images/$size/$id';
  }

  static String getAvatarUrl(String name) {
    return 'https://ui-avatars.com/api/?background=736CED&color=fff&name=$name';
  }
}
