require "rspec"

RSpec::Matchers.define :have_content do |expected|
  match do |actual|
    actual.content.include? expected
  end
  failure_message_for_should do |actual|
    "expected \"#{actual.content.join("\n")}\" to include \"#{expected}\""
  end
end

RSpec::Matchers.define :have_text do |expected|
  match do |actual|
    actual.has_text? expected
  end
  failure_message_for_should do |actual|
    <<-FAIL
    expected "#{actual.content.join("\n")}" to include "#{expected}"
    all content on page:
    #{actual.all_content.join("\n")}
    FAIL
  end
end
