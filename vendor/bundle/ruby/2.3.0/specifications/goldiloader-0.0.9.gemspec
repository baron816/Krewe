# -*- encoding: utf-8 -*-
# stub: goldiloader 0.0.9 ruby lib

Gem::Specification.new do |s|
  s.name = "goldiloader"
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joel Turkel"]
  s.date = "2015-04-14"
  s.description = "Automatically eager loads Rails associations as associations are traversed"
  s.email = ["jturkel@salsify.com"]
  s.homepage = "https://github.com/salsify/goldiloader"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Automatic Rails association eager loading"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["< 4.3", ">= 3.2"])
      s.add_runtime_dependency(%q<activesupport>, ["< 4.3", ">= 3.2"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 1.2"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7.1"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, ["< 4.3", ">= 3.2"])
      s.add_dependency(%q<activesupport>, ["< 4.3", ">= 3.2"])
      s.add_dependency(%q<coveralls>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, [">= 1.2"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2"])
      s.add_dependency(%q<simplecov>, ["~> 0.7.1"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["< 4.3", ">= 3.2"])
    s.add_dependency(%q<activesupport>, ["< 4.3", ">= 3.2"])
    s.add_dependency(%q<coveralls>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, [">= 1.2"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2"])
    s.add_dependency(%q<simplecov>, ["~> 0.7.1"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
