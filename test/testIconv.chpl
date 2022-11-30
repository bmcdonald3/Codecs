use UnitTest;
use Codecs, CTypes;

proc iconvTest(test: borrowed Test) throws {
  var iconvVer = iconv._libiconv_version:string;
  test.assertTrue(iconvVer.size > 0);
}

proc encodeTest(test: borrowed Test) throws {
  var encoded = encodeStr("asd", toEncoding="ascii");
  writeln(encoded);
}

UnitTest.main();
