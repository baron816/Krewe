# -*- encoding: utf-8 -*-
# stub: sweet-alert-confirm 0.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sweet-alert-confirm"
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Moises Viloria"]
  s.date = "2015-11-26"
  s.description = ""
  s.email = ["moisesviloria@gmail.com"]
  s.homepage = "http://www.github.com/mois3x/sweet-alert-rails-confirm"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "A Rails confirm replacement with SweetAlert"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rails>, [">= 3.1"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<capybara>, ["~> 2.1"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.1"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<capybara>, ["~> 2.1"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.1"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<capybara>, ["~> 2.1"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
