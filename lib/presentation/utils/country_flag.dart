String countryFlagUrl(String countryCode, bool big) {
  final size = big ? '32' : '16';
  return 'https://www.countryflags.io/${countryCode.toLowerCase()}/flat/$size.png';
}
