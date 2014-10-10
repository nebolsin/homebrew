require "formula"

class Ndenv < Formula
  homepage "https://github.com/nebolsin/ndenv"
  head "https://github.com/nebolsin/ndenv.git"
  url "https://github.com/nebolsin/ndenv/archive/v20141024.tar.gz"
  sha1 "8b458d0227f3ca6297c51fc6b079c1c343196619"

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]

  def install
    inreplace "libexec/ndenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/ndenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    rm_f "#{var_lib}/plugins/node-build"
    ln_sf "#{prefix}/default-plugins/node-build", "#{var_lib}/plugins/node-build"
    %w[ndenv-install ndenv-uninstall node-build].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/node-build/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which ndenv > /dev/null; then eval "$(ndenv init -)"; fi

    To use Homebrew's directories rather than ~/.ndenv add to your profile:
      export NDENV_ROOT=#{opt_prefix}
    EOS
  end
end
