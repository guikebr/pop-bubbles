require 'yaml'

class UpdateVersion

 @@version = ""
 @@yaml_version = ""
 @@yaml_file = YAML.load(File.read("pubspec.yaml"))

  def saveVersioningYAML(fileToSave)
   File.open(File.expand_path('~/apps_version.yaml'), 'w') { |file| YAML.dump(fileToSave, file) }
   p 'New line Created!'
  end

  def loadVersioningYamlFile
    @@yaml_version = YAML.load(File.read(File.expand_path('~/apps_version.yaml')))
  end

  def createYamlFile
   p 'Creating YAML file ....'
   system('touch ~/apps_version.yaml')
   line = {ARGV[0] => @@yaml_file["version"]}
   saveVersioningYAML(line)
   loadVersioningYamlFile
  end

  def validateifFileHasProjectLineVersion
   p 'Validating lines ...'
   searchField = @@yaml_version.select { |key, value| key == ARGV[0] }
   if searchField.empty? == true
    p '[~/app_versions.yaml] Creating versioning line for this project...'
    @@yaml_version.merge!({ARGV[0] =>  @@yaml_file["version"]})
    saveVersioningYAML(@@yaml_version)
   end
   loadVersioningYamlFile
  end

 def updateAppYAML
  currentVersion = @@yaml_version[ARGV[0]]

  @@version = currentVersion.chomp("\n") .split('+')[0].split('.')
  buildNumber = currentVersion.chomp("\n") .split('+')[1].to_i + 1

  @@version = "#{@@version[0]}.#{@@version[1]}.#{@@version[2].to_i + 1}+#{buildNumber}"

  @@yaml_file["version"] = @@version
  File.open("pubspec.yaml", 'w') { |file| YAML.dump(@@yaml_file, file) }

  puts "New version #{@@version}"
 end

 def updateVersioningYAML
  @@yaml_version[ARGV[0]] = @@version
  File.open(File.expand_path('~/apps_version.yaml'), 'w') { |file| YAML.dump(@@yaml_version, file) }
 end

 if __FILE__ == $0
  update = UpdateVersion.new
  if File.exist?(File.expand_path('~/apps_version.yaml')) === false
   update.createYamlFile
  end
  update.loadVersioningYamlFile
  update.validateifFileHasProjectLineVersion
  update.updateAppYAML
  update.updateVersioningYAML
 end
end
