# -*- encoding: utf-8 -*-
# stub: lol_dba 2.0.3 ruby lib lib/lol_dba

Gem::Specification.new do |s|
  s.name = "lol_dba".freeze
  s.version = "2.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "lib/lol_dba".freeze]
  s.authors = ["Diego Plentz".freeze, "Elad Meidar".freeze, "Eric Davis".freeze, "Muness Alrubaie".freeze, "Vladimir Sharshov".freeze]
  s.date = "2016-01-09"
  s.description = "lol_dba is a small package of rake tasks that scan your application models and displays a list of columns that probably should be indexed. Also, it can generate .sql migration scripts.".freeze
  s.email = ["diego@plentz.org".freeze, "elad@eizesus.com".freeze, "".freeze, "vsharshov@gmail.com".freeze]
  s.executables = ["lol_dba".freeze]
  s.files = ["bin/lol_dba".freeze]
  s.homepage = "https://github.com/plentz/lol_dba".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.6.3".freeze
  s.summary = "A small package of rake tasks to track down missing database indexes and generate sql migration scripts".freeze

  s.installed_by_version = "2.6.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, ["< 5.0", ">= 3.0"])
      s.add_runtime_dependency(%q<actionpack>.freeze, ["< 5.0", ">= 3.0"])
      s.add_runtime_dependency(%q<railties>.freeze, ["< 5.0", ">= 3.0"])
      s.add_development_dependency(%q<appraisal>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<activerecord>.freeze, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<actionpack>.freeze, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<railties>.freeze, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<appraisal>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<actionpack>.freeze, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<railties>.freeze, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<appraisal>.freeze, ["~> 1.0"])
  end
end
