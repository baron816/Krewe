# -*- encoding: utf-8 -*-
# stub: jquery-atwho-rails 1.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "jquery-atwho-rails".freeze
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["ichord".freeze]
  s.date = "2015-06-25"
  s.description = "This is a jQuery plugin\n    that implement Github-like mentions.".freeze
  s.email = ["chord.luo@gmail.com".freeze]
  s.homepage = "http://ichord.github.com/jquery-atwho-rails".freeze
  s.rubyforge_project = "jquery-atwho-rails".freeze
  s.rubygems_version = "2.6.3".freeze
  s.summary = "jquery plugin: @mentions".freeze

  s.installed_by_version = "2.6.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<generator_spec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<generator_spec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<generator_spec>.freeze, [">= 0"])
  end
end
