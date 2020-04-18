require 'nu/validator'
require 'open-uri'

ARGV.each do |arg|
  doc = Nu::Validator::parse(open(arg))
  doc.xpath("//*[local-name()='font']").each do |font|
    font.attributes.each do |name, attr|
      puts "#{name} => #{attr.value}"
    end
  end
end
