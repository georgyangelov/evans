require 'spec_helper'

describe 'Linting C++ code', cpp: true do
  it 'checks for syntax errors' do
    errors = Language::Cpp.lint <<~CPP
      #include <iostream>

      using namespace std;

      int test() {
        return 0
      }
    CPP

    errors.first.should include 'error: expected \';\' after return statement'
  end

  it 'returns true for valid code' do
    errors = Language::Cpp.lint <<~CPP
      #include <iostream>

      using namespace std;

      int test() {
        cout << "Hello world";
        return 0;
      }
    CPP

    errors.should eq []
  end

  it 'supports C++17' do
    errors = Language::Cpp.lint <<~CPP
      #include <tuple>

      int test() {
        auto [a, i, b] = std::tuple('a', 123, true);

        return i;
      }
    CPP

    errors.should eq []
  end

  it 'returns true for no code' do
    Language::Cpp.lint('').should eq []
  end

  it 'returns false if code contains main function definition' do
    errors = Language::Cpp.lint <<~CPP
      int main() {
        return 0;
      }
    CPP

    errors.first.should include 'redefinition of \'main\''
  end

  it 'returns false for code including non-existent headers' do
    errors = Language::Cpp.lint <<~CPP
      #include "bla.h"

      int test() {
        return 0;
      }
    CPP

    errors.first.should include 'fatal error: \'bla.h\' file not found'
  end
end
