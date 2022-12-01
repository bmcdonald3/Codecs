/* A Chapel-native string encoding library 

  This module contains the implementation of and encodeStr function that
  can convert to/from all encodings supported by iconv and, additionally,
  idna.

  In order to use this module, the libidn2 and libiconv dependencies are
  required. To compile with those libraries, the include path, library
  path and linker path must all be specified using `-I`, `-L`, and `-l`
  respectively.

  A sample command to run the test isis:
  mason test --show -- -I/usr/local/Caskroom/miniforge/base/envs/arkouda-dev/include \
  -L/usr/local/Caskroom/miniforge/base/envs/arkouda-dev/lib \
  --ldflags="-Wl,-rpath,/usr/local/Caskroom/miniforge/base/envs/arkouda-dev/lib" \
  -liconv -lidn2
*/

module Codecs {
  use CTypes;
  include module idna;
  include module iconv;

  /*
    Perform encoding/decoding on a given string

    :arg inputStr: The string to encode/decode.
    :arg toEncoding: The desired encoding of the output string.
    :arg fromEncoding: The current encoding of inputStr
  */
  proc encodeStr(inputStr: string, toEncoding: string = "UTF-8", fromEncoding: string = "UTF-8"): string throws {
    if toEncoding.toUpper() == "IDNA" {
      if fromEncoding != "UTF-8" {
        throw new Error("Only encoding from UTF-8 is supported for IDNA encoding");
      }
      var cRes: c_string;
      var rc = idna.idn2_to_ascii_lz(inputStr.c_str(), cRes, 0);
      if (rc != idna.IDNA_SUCCESS) {
        throw new Error("Encode failed");
      }
      var ret = cRes: string;
      idna.idn2_free(cRes: c_void_ptr);
      return ret;
    } else if fromEncoding.toUpper() == "IDNA" {
      if toEncoding != "UTF-8" {
        throw new Error("Only encoding to UTF-8 is supported for IDNA encoding");
      }
      var cRes: c_string;
      var rc = idna.idn2_to_unicode_8z8z(inputStr.c_str(), cRes, 0);
      if (rc != idna.IDNA_SUCCESS) {
        throw new Error("Decode failed");
      }
      var ret = cRes: string;
      idna.idn2_free(cRes: c_void_ptr);
      return ret;
    } else {
      var cd = iconv.libiconv_open(toEncoding.c_str(), fromEncoding.c_str());
      if cd == (-1):iconv.libiconv_t then
        throw new Error("Unsupported encoding: " + toEncoding + " " + fromEncoding);
      var inBuf = inputStr.c_str();
      var inSize = (inputStr.size+1): c_size_t;

      // maximum possible output size is 4 times input size
      var chplRes = " "*(inSize:int*4);
      var outSize = (inSize*4): c_size_t;
      var origOutSize = outSize;
      
      var outBuf = chplRes.c_str();
      
      if iconv.libiconv(cd, inBuf, inSize, outBuf, outSize) != 0 then
        throw new Error("Encoding to " + toEncoding + " failed");
      iconv.libiconv_close(cd);

      var ret = chplRes[0..#(origOutSize-outSize-1)];
      return ret;
    }
  }
}
