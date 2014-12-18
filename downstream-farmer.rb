require 'formula'
require 'fileutils'

class DownstreamFarmer < Formula
  homepage 'http://driveshare.org/'
  url 'https://github.com/Storj/downstream-farmer/archive/v0.1.4-alpha.tar.gz'
  version '0.1.4-alpha'
  sha1 'be5f8f0437caa93aac1a06588461ac8b40a259ba'

  head 'https://github.com/storj/downstream-farmer.git'

  depends_on 'python'
  depends_on :python3 => :optional
  depends_on 'openssl'
  depends_on 'cryptopp'

  def install
    system 'pip install virtualenv'

    venv_path = "#{Dir.home}/.venvs/downstream"
    unless Dir.exists?(venv_path)
      system "virtualenv #{venv_path}"
    end

    system "#{venv_path}/bin/python setup.py install"

    FileUtils.ln_s "#{venv_path}/bin/downstream", '/usr/local/bin/downstream', :force => true
  end

  def caveats
    s = <<-EOS.undent
        You can now start your farmer using the `downstream` command.

        Be sure to run your farmer in a directory where your user has
        write access so a `data` folder can be created if it does not
        exist already.
      EOS
    s
  end
end
