require 'spec_helper'

describe 'Running C++ tests', cpp: true do
  let :test_case_code do
    <<~CPP
      TEST_CASE("our_strcat appends two simple strings") {
          char dest[100] = "Hello ";

          our_strcat(dest, "world!");

          CHECK(strcmp(dest, "Hello world!") == 0);
      }

      TEST_CASE("our_strcat appends empty strings") {
          char dest[100] = "Hello";

          our_strcat(dest, "");

          CHECK(strcmp(dest, "Hello") == 0);
      }

      TEST_CASE("our_strcat appends to empty strings") {
          char dest[100] = "";

          our_strcat(dest, "world");

          CHECK(strcmp(dest, "world") == 0);
      }
    CPP
  end

  it 'handles solutions that do not compile' do
    solution = '#include "bla.h"'
    results = Language::Cpp.run_tests(test_case_code, solution)

    results.passed_count.should eq 0
    results.failed_count.should eq 0
    results.log.should include 'fatal error: \'bla.h\' file not found'
  end

  it 'collects successful/failed tests and execution log' do
    solution = <<~CPP
      char* our_strcat(char* dest, const char* source) {
        if (!*dest) {
          return dest;
        }

        while (*dest) dest++;

        while (*source) {
            *dest = *source;

            dest++;
            source++;
        }

        *dest = 0;

        return dest;
      }
    CPP

    results = Language::Cpp.run_tests(test_case_code, solution)

    results.passed_count.should eq 2
    results.failed_count.should eq 1
    results.log.should include('Status: FAILURE!')
  end

  it 'handles crashes' do
    solution = <<~CPP
      char* our_strcat(char* dest, const char* source) {
        dest[100000] = 'a';

        return dest;
      }
    CPP

    results = Language::Cpp.run_tests(test_case_code, solution)

    results.passed_count.should eq 0
    results.failed_count.should eq 0
    results.log.should include 'Segmentation fault'
  end

  it 'handles timeouts' do
    solution = <<~CPP
      char* our_strcat(char* dest, const char* source) {
        while (*dest) {}

        return dest;
      }
    CPP

    results = Language::Cpp.run_tests(test_case_code, solution)

    results.passed_count.should eq 0
    results.failed_count.should eq 0
    results.log.should include 'sending signal TERM'
  end
end
