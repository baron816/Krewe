# -*- encoding: utf-8 -*-
# stub: sweetalert-rails 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sweetalert-rails"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Rustam Sharshenov"]
  s.date = "2015-03-28"
  s.description = "This gem provides SweerAlert for your Rails application."
  s.email = ["rustam@sharshenov.com"]
  s.homepage = "https://github.com/sharshenov/sweetalert-rails"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Use SweerAlert with Rails"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1.0"])
    else
      s.add_dependency(%q<railties>, [">= 3.1.0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1.0"])
  end
end
