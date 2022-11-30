use UnitTest;
use Codecs, CTypes;

proc idnaTest(test: borrowed Test) throws{
  var idnaCVerStr = idna.idn2_check_version(c_nil);
  var idnaVerStr = idnaCVerStr:string;
  test.assertTrue(idnaVerStr.size > 0);
}

proc idnaEncodeTest(test: borrowed Test) throws {
  var originalString = "ドメイン.テスト";
  var expected = "xn--eckwd4c7c.xn--zckzah";
  var encodedString = encodeStr(originalString, toEncoding="idna");
  test.assertTrue(expected == encodedString);
}

UnitTest.main();
