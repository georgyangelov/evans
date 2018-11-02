require 'spec_helper'

describe 'Parsing C++ code', cpp: true do
  it 'returns false for syntax errors' do
    Language::Cpp.should_not be_parsing <<~CPP
      #include <iostream>

      using namespace std;

      int test() {
        return 0
      }
    CPP
  end

  it 'returns true for valid code' do
    Language::Cpp.should be_parsing <<~CPP
      #include <iostream>

      using namespace std;

      int test() {
        cout << "Hello world";
        return 0;
      }
    CPP
  end

  it 'supports C++17' do
    Language::Cpp.should be_parsing <<~CPP
      #include <tuple>

      int test() {
        auto [a, i, b] = std::tuple('a', 123, true);

        return i;
      }
    CPP
  end

  it 'returns true for no code' do
    Language::Cpp.should be_parsing ''
  end

  it 'returns false if code contains main function definition' do
    Language::Cpp.should_not be_parsing <<~CPP
      int main() {
        return 0;
      }
    CPP
  end

  it 'returns false for code including non-existent headers' do
    Language::Cpp.should_not be_parsing <<~CPP
      #include "bla.h"

      int test() {
        return 0;
      }
    CPP
  end
end
