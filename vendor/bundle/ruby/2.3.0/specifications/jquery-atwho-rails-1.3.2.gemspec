# -*- encoding: utf-8 -*-
# stub: jquery-atwho-rails 1.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "jquery-atwho-rails"
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["ichord"]
  s.date = "2015-06-25"
  s.description = "This is a jQuery plugin\n    that implement Github-like mentions."
  s.email = ["chord.luo@gmail.com"]
  s.homepage = "http://ichord.github.com/jquery-atwho-rails"
  s.rubyforge_project = "jquery-atwho-rails"
  s.rubygems_version = "2.5.1"
  s.summary = "jquery plugin: @mentions"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<generator_spec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<generator_spec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<generator_spec>, [">= 0"])
  end
end
