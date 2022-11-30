use UnitTest;
use Codecs, CTypes;

proc iconvTest(test: borrowed Test) throws {
  var iconvVer = iconv._libiconv_version:string;
  test.assertTrue(iconvVer.size > 0);
}

proc iconvEncodeTest(test: borrowed Test) throws {
  var originalString = "test string";
  var encodedString = encodeStr(originalString, toEncoding="ascii");
  test.assertTrue(originalString == encodedString);
}

UnitTest.main();
