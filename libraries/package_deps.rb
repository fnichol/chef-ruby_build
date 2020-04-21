class Chef
  module Rbenv
    module PackageDeps
      def jruby_package_deps
        case node['platform_family']
        when 'debian'
          %w( make g++ )
        when 'freebsd'
          %w( alsa-lib bash dejavu expat fixesproto fontconfig freetype2 gettext-runtime giflib indexinfo inputproto java-zoneinfo javavmwrapper kbproto libICE libSM libX11 libXau libXdmcp libXext libXfixes libXi libXrender libXt libXtst libfontenc libpthread-stubs libxcb libxml2 mkfontdir mkfontscale openjdk8 recordproto renderproto xextproto xproto )
        else
          %w( make gcc-c++ )
        end
      end

      def cruby_package_deps
        case node['platform']
        when 'rhel', 'fedora', 'amazon'
          %w( gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel make )
        when 'debian'
          if node['platform_version'].to_i >= 10
            %w( gcc autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev make )
          else
            %w(gcc autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev make)
          end
        when 'ubuntu'
          if node['platform_version'].to_i >= 18
            %w( gcc autoconf bison build-essential libssl1.0-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev make )
          else
            %w(gcc autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev make)
          end
        when 'suse'
          %w( gcc make automake gdbm-devel libyaml-devel ncurses-devel readline-devel zlib-devel libopenssl-devel )
        end
      end

      def rbx_package_deps
        case node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          %w( ncurses-devel llvm-static llvm-devel ) + cruby_package_deps
        when 'suse'
          %w( ncurses-devel ) + cruby_package_deps
        end
      end

      def package_deps(definition)
        case ::File.basename(definition)
        when /^\d\.\d\.\d/, /^ree-/
          cruby_package_deps
        when /^rbx-/
          rbx_package_deps
        when /^jruby-/
          jruby_package_deps
        end
      end
    end
  end
end
