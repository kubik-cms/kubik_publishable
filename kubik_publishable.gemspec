# frozen_string_literal: true

require_relative "lib/kubik_publishable/version"

Gem::Specification.new do |spec|
  spec.name = "kubik_publishable"
  spec.version = KubikPublishable::VERSION
  spec.summary = "Publishable module for Kubik CMS"
  spec.description = "Shared publish/unpublish semantics and admin actions for Kubik content"
  spec.authors = ["Kubik CMS"]
  spec.email = ["dev@kubik.cms"]
  spec.homepage = "https://github.com/kubik-cms/kubik_publishable"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    files = `git ls-files -z 2>/dev/null`.split("\x0")
    if files.empty?
      Dir.glob("{lib}/**/*", File::FNM_DOTMATCH).select { |f| File.file?(f) } + ["README.md"]
    else
      files.reject { |f| f.match(%r{\A(?:test|spec)/}) }
    end
  end

  spec.required_ruby_version = ">= 3.1.0"
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activeadmin", ">= 3.0"
  spec.add_runtime_dependency "activerecord", ">= 7.0"
  spec.add_runtime_dependency "nokogiri", ">= 1.0"
  spec.add_runtime_dependency "rails", ">= 7.0"
end
