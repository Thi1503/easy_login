enum AppImages {
  logo('assets/images/logo.svg'),
  closeCircle('assets/images/close-circle.svg'),
  eye('assets/images/eye.svg'),
  eyeSlash('assets/images/eye-slash.svg'), // đổi tên và path
  group('assets/images/group.svg'),
  headphone('assets/images/headphone.svg'),
  searchNormal('assets/images/search-normal.svg');

  final String path;
  const AppImages(this.path);
}
