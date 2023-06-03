"""Macros for defining lit tests."""

# TODO: try replacing this with a lit.cfg.py config (test_exec_root? test_src_root?)
_TESTS_DIR = "tests"
_DEFAULT_FILE_EXTS = ["mlir"]

def lit_test(name = None, src = None, size = "small"):
    """Define a lit test.

    In its simplest form, a manually defined lit test would look like this:

      py_test(
          name = "ops.mlir.test",
          srcs = ["@llvm_project//llvm:lit"],
          args = ["-v", "tests/ops.mlir"],
          data = [":test_utilities", ":ops.mlir"],
          size = "small",
          main = "lit.py",
      )

    Where the `ops.mlir` file contains the test cases in standard RUN + CHECK format.

    The adjacent :test_utilities target contains all the tools (like mlir-opt) and
    files (like lit.cfg.py) that are needed to run a lit test. lit.cfg.py further
    specifies the lit configuration, including augmenting $PATH to include heir-opt.

    This macro simplifies the above definition by filling in the boilerplate.

    Args:
      name: the name of the test.
      src: the source file for the test.
      size: the size of the test.
    """
    if not src:
        fail("src must be specified")
    name = name or src + ".test"
    rel_target = ":" + src

    native.py_test(
        name = name,
        size = size,
        # -v ensures lit outputs useful info during test failures
        args = ["-v", _TESTS_DIR + "/" + src],
        data = ["@heir//tests:test_utilities", rel_target],
        srcs = ["@llvm-project//llvm:lit"],
        main = "lit.py",
    )

def glob_lit_tests(
        # these unused args are kept for API compability with the corresponding
        # google-internal macro
        name = None,  # buildifier: disable=unused-variable
        data = None,  # buildifier: disable=unused-variable
        driver = None,  # buildifier: disable=unused-variable
        size_override = None,
        test_file_exts = None):
    """Searches the caller's directory for files to run as lit tests.

    Args:
      name: unused
      data: unused
      driver: unused
      size_override: a dictionary giving per-source-file test size overrides
      test_file_exts: a list of file extensions to use for globbing for files
        that should be defined as tests.
    """
    test_file_exts = test_file_exts or _DEFAULT_FILE_EXTS
    size_override = size_override or dict()
    tests = native.glob(["*." + ext for ext in test_file_exts])

    for curr_test in tests:
        lit_test(
            src = curr_test,
            size = size_override.get(curr_test, "small"),
        )