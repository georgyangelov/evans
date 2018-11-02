module Language::Cpp
  extend self

  TIMEOUT_TIME = '5s'.freeze

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

  def solution_dump(attributes)
    <<~TEXT
    // #{attributes[:name]}
    // #{attributes[:faculty_number]}
    // #{attributes[:url]}

    #{attributes[:code]}

    // Log output
    // ----------
    #{attributes[:log].lines.map { |line| "// #{line}".strip }.join("\n")}
    TEXT
  end

  # TODO: Provide explanation
  def parsing?(code)
    TempDir.for('code.cpp' => code) do |dir|
      code_path = dir.join('code.cpp')

      File.open code_path, 'a' do |code|
        code.write("\n\nint main() { return 0; }")
      end

      system "clang++ -fsyntax-only -std=c++17 #{code_path} > /dev/null 2>&1"
    end
  end

  def run_tests(test, solution)
    includes = File.expand_path('cpp/includes', File.dirname(__FILE__))
    runner   = File.read File.expand_path('cpp/runner.cpp', File.dirname(__FILE__))

    TempDir.for(
      'solution.cpp' => solution,
      'test.cpp'     => test,
      'runner.cpp'   => runner
    ) do |dir|
      output = nil

      FileUtils.cd dir do
        output = `{ clang++ -std=c++17 -I"#{includes}" runner.cpp && timeout -k #{TIMEOUT_TIME} -v #{TIMEOUT_TIME} ./a.out; } 2>&1`
      end

      unless output.include? '[doctest] test cases:'
        return TestResults.new(log: output, passed: [], failed: [])
      end

      stats_line = output.lines.find { |line| line.include? '[doctest] test cases:' }

      passed_tests  = stats_line.match(/(\d+) passed/).captures[0].to_i
      failed_tests  = stats_line.match(/(\d+) failed/).captures[0].to_i
      skipped_tests = stats_line.match(/(\d+) skipped/).captures[0].to_i

      TestResults.new(
        log: output,
        passed: ['*'] * passed_tests,
        failed: ['*'] * (failed_tests + skipped_tests)
      )
    end
  end
end
