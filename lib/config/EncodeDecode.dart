import 'dart:convert';

class EncodeDecode {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encode(stringToBeEncoded) {
    String encoded = stringToBase64.encode(stringToBeEncoded.toString());
    return encoded;
  }

  String decode(encodedString) {
    String decoded = stringToBase64.decode(encodedString);
    return decoded;
  }
}
