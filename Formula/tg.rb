class Tg < Formula
  desc "Template Generator - CLI tool for project scaffolding"
  homepage "https://github.com/Naviary-Sanctuary/template_generator"
  url "https://github.com/Naviary-Sanctuary/template_generator/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "33bb8f035e257a3f39af65a209bb0227b302bf7798601f8ef62129d6f2e69645"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/Naviary-Sanctuary/template_generator/internal/cli.Version=#{version}"), "./cmd"
  end

  test do
    system "bin/tg", "--version"
  end
end
