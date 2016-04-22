# -*- encoding: utf-8 -*-
# stub: access-granted 1.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "access-granted"
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Piotrek Oko\u{144}ski"]
  s.date = "2015-11-26"
  s.description = "Role based authorization gem"
  s.email = ["piotrek@okonski.org"]
  s.homepage = "https://github.com/chaps-io/access-granted"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Elegant whitelist and role based authorization with ability to prioritize roles."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
  end
end
