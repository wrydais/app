require 'json'

module Jekyll
  class JsonApiGenerator < Generator
    def generate(site)
      if site.active_lang == site.default_lang
        dir = File.join(site.dest, 'api', 'v1', 'packages')
        FileUtils.mkdir_p(dir)
        site.pages.each do |page|
          if page.data and page.data.key? 'package_name'
            if /.*\.(coffee|css|html|js|md)$/.match(page.data['package_name'])
              # TODO temporary hack to stop https://gitlab.com/fdroid/fdroid-website/-/issues/517
              next
            end
            site.pages << JsonApi.new(site, dir, page.data)
          end
        end
      end
    end
  end

  class JsonApi < Page
    def initialize(site, dir, data)
      name = data['package_name']
      json = {
        'packageName' => data['package_name'],
        'suggestedVersionCode' => data['suggested_version_code'],
        'packages' => (data['packages'] || []).map do |package|
          {
            'versionName' => package['version_name'],
            'versionCode' => package['version_code']
          }
        end
      }
      File.open(File.join(dir, name), 'w') do |file|
        file.write(json.to_json)
      end
      super(site, site.source, dir, name)
    end
  end
end
