/// email validator
String? validateEmail({required String string}) { 
  String regex = r'^[a-zA-Z0-9._+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z-]{2,})+$';
  if (!validRegexExp(regex, string.trim())) {
    return "Invalid Email";
  } else if (string.length > 254) {
    return "Upto 250 characters";
  } else {
    return null;
  }
}

bool validRegexExp(String regex, String string) {
  return RegExp(regex).hasMatch(string);
}
