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
    brew_prefix = '/usr/local'
    system "#{brew_prefix}/bin/pip", 'install', 'virtualenv'

    venv_path = "#{Dir.home}/.venvs/downstream"
    unless Dir.exists?(venv_path)
      system "#{brew_prefix}/bin/virtualenv", venv_path
    end

    system "#{venv_path}/bin/python", "setup.py", "install"

    FileUtils.ln_s "#{venv_path}/bin/downstream", '/usr/local/bin/downstream', :force => true
  end

  def caveats
    s = <<-EOS.undent
        You can now start your farmer using the `downstream` command.

        Be sure to run your farmer in a directory where your user has
        write access so a `data` folder can be created if it does not
        exist already.

        If address signing is enabled, you will need to create the 
        `data/` directory in the same location you are running
        `downstream`. This folder must contain an `identities.json`
        file. For example, on Counterwallet, click on Address Actions,
        and then Sign Message. Type a message of your choice, and click
        Sign. Then copy and paste the message and signature into the 
        `identities.json` file in the data/ directory.

        The format should look similar to:

        {
          "19qVgG8C6eXwKMMyvVegsi3xCsKyk3Z3jV": {
            "message": "test message",
            "signature": "HyzVUenXXo4pa+kgm1vS8PNJM83eIXFC5r0q86FGbqFcdla6rcw72/ciXiEPfjli3ENfwWuESHhv6K9esI0dl5I="
          }
        }
      EOS
    s
  end
end
