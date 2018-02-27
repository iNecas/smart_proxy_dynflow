module SmartProxyDynflowCore
  class BundlerHelper
    # rubocop:disable Metrics/PerceivedComplexity
    def self.require_groups(*groups)
      if File.exist?(File.expand_path('../../../Gemfile.in', __FILE__))
        # If there is a Gemfile.in file, we will not use Bundler but BundlerExt
        # gem which parses this file and loads all dependencies from the system
        # rathern then trying to download them from rubygems.org. It always
        # loads all gemfile groups.
        begin
          require 'bundler_ext' unless defined?(BundlerExt)
        rescue LoadError
          # Debian packaging guidelines state to avoid needing rubygems, so
          # we only try to load it if the first require fails (for RPMs)
          begin
            begin
              require 'rubygems'
            rescue StandardError
              nil
            end
            require 'bundler_ext'
          rescue LoadError
            puts "`bundler_ext` gem is required to run smart_proxy"
            exit 1
          end
        end
        BundlerExt.system_require(File.expand_path('../../../Gemfile.in', __FILE__), *groups)
      else
        require 'bundler' unless defined?(Bundler)
        Bundler.require(*groups)
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity
  end
end
