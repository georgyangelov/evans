module Language::Cpp
  extend self

  def language
    :cpp
  end

  def extension
    'cpp'
  end

  def can_lint?
    false
  end

  def test_file_pattern
    'test.cpp'
  end

  def solution_dump(_attributes)
    'Not supported'
  end

  def parsing?(_code)
    true
  end

  def run_tests(test, solution)
    TestResults.new({
      log: 'Not yet supported',
      passed: [],
      failed: [],
    })
  end
end
