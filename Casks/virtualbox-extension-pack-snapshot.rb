cask "virtualbox-extension-pack-snapshot" do
  version :latest
  sha256 :no_check

  url do
    require "open-uri"
    downloads_url = "https://www.virtualbox.org/wiki/Testbuilds"
    version = URI(downloads_url.to_s)
              .open.read
              .scan(/href=".*(Oracle_VM_VirtualBox_Extension_Pack-\d+.\d+.+\d+-\d+.vbox-extpack)"/)
              .flatten.last
    "https://www.virtualbox.org/download/testcase/#{version}"
  end
  name "Oracle VirtualBox Extension Pack Development Snapshot"
  homepage "https://www.virtualbox.org/wiki/Testbuilds"

  conflicts_with cask: [
    "virtualbox-extension-pack",
    "virtualbox-extension-pack-beta",
  ]
  depends_on cask: "virtualbox-snapshot"
  container type: :naked

  stage_only true

  real_version = url.to_s.scan(/(?:\d+\.?)+-\d+/).flatten.last
  postflight do
    system_command "/usr/local/bin/VBoxManage",
                   args:  [
                     "extpack", "install",
                     "--replace", "#{staged_path}/Oracle_VM_VirtualBox_Extension_Pack-#{real_version}.vbox-extpack",
                     "--accept-license=56be48f923303c8cababb0bb4c478284b688ed23f16d775d729b89a2e8e5f9eb"
                   ],
                   input: "y",
                   sudo:  true
  end

  uninstall_postflight do
    next unless File.exist?("/usr/local/bin/VBoxManage")

    system_command "/usr/local/bin/VBoxManage",
                   args: [
                     "extpack", "uninstall",
                     "Oracle VM VirtualBox Extension Pack"
                   ],
                   sudo: true
  end

  caveats do
    license "https://www.virtualbox.org/wiki/VirtualBox_PUEL"
  end
end
