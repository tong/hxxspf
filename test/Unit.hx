
class Unit implements utest.ITest {

	static function main() {
		var runner = new utest.Runner();
		runner.addCase( new TestXSPF() );
		var report = utest.ui.Report.create( runner );
		runner.run();
	}

}
