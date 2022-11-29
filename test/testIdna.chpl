use UnitTest;
use Codecs, CTypes;

proc idnaTest(test: borrowed Test) throws{
  var idnaCVerStr = idna.idn2_check_version(c_nil);
  var idnaVerStr = idnaCVerStr:string;
  test.assertTrue(idnaVerStr.size > 0);
}

UnitTest.main();
