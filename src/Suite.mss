function Suite(name, target, plugin) {
	//$module(Suite.mss)
  s = CreateDictionary(
    'name', name,
    'target', target,
    'plugin', plugin,
    'tests', CreateSparseArray()
  );
  s.SetMethod('Add',    Self, '_add');
  s.SetMethod('AddModule', Self, '_addModule');
  s.SetMethod('Run',    Self, '_run');

  return s;
} //$end

function _add(this, testName) {
  //$module(Suite.mss)
  this.tests.Push(testName);
  return this;
}  //$end

function _addModule(this, testCollectionName) {
  //$module(Suite.mss)
  target = this.target;
  target.@testCollectionName(this);
  return this;
}  //$end

function _run(this) {
  //$module(Suite.mss)
  Sibelius.ShowTraceWindow();

  trace('Running test suite ' & this.name);
  target = this.target;
  plugin = this.plugin;

  failed = 0;
  passed = 0;

  Sibelius.CreateProgressDialog('Running test suite ' & this.name, 0, this.tests.Length);

  for i = 0 to this.tests.Length {
    testName = this.tests[i];
    if (not Sibelius.UpdateProgressDialog(i, testName)) {
      trace('=====================');
      trace('Tests aborted');
      return False;
    }
    assert = Assert();
    result = target.@testName(assert, plugin);
    if (assert.failed = True) {
      trace('FAIL: ' & testName);
      failed = failed + 1;
    } else {
      trace('OK: ' & testName);
      passed = passed + 1;
    }
  }

  Sibelius.DestroyProgressDialog();

  trace('=====================');
  trace((failed + passed) & ' tests, ' & failed & ' failed');

  return True;
} //$end
