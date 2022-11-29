use UnitTest;
use Codecs, CTypes;

proc iconvTest(test: borrowed Test) throws{
  var iconvVer = iconv._libiconv_version:string;
  test.assertTrue(iconvVer.size > 0);
}

UnitTest.main();
