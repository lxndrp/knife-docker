# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # Setup virtual machine box. This VM configuration code is always executed.
  config.vm.box =         'base-ubuntu-12.04'
  config.vm.box_url =     'https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_chef-11.2.0.box'
  config.vm.forward_port  4243, 4243
  config.vm.share_folder  "keppel", "/home/vagrant/keppel", "."

  # Provision docker and new kernel if deployment was not done
  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    # Add lxc-docker package
    pkg_cmd = "apt-get update -qq; apt-get install -q -y python-software-properties; " \
      "add-apt-repository -y ppa:dotcloud/lxc-docker; apt-get update -qq; " \
      "apt-get install -q -y lxc-docker; "
    # Add X.org Ubuntu backported 3.8 kernel
    pkg_cmd << "add-apt-repository -y ppa:ubuntu-x-swat/r-lts-backport; " \
      "apt-get update -qq; apt-get install -q -y linux-image-3.8.0-19-generic; "
    # Add guest additions if local vbox VM
    is_vbox = true
    ARGV.each do |arg| is_vbox &&= !arg.downcase.start_with?("--provider") end
    if is_vbox
      pkg_cmd << "apt-get install -q -y linux-headers-3.8.0-19-generic dkms; " \
        "echo 'Downloading VBox Guest Additions...'; " \
        "wget -q http://dlc.sun.com.edgesuite.net/virtualbox/4.2.12/VBoxGuestAdditions_4.2.12.iso; "
      # Prepare the VM to add guest additions after reboot
      pkg_cmd << "echo -e 'mount -o loop,ro /home/vagrant/VBoxGuestAdditions_4.2.12.iso /mnt\n" \
        "echo yes | /mnt/VBoxLinuxAdditions.run\numount /mnt\n" \
          "rm /root/guest_additions.sh; ' > /root/guest_additions.sh; " \
        "chmod 700 /root/guest_additions.sh; " \
        "sed -i -E 's#^exit 0#[ -x /root/guest_additions.sh ] \\&\\& /root/guest_additions.sh#' /etc/rc.local; " \
        "echo 'Installation of VBox Guest Additions is proceeding in the background.'; " \
        "echo '\"vagrant reload\" can be used in about 2 minutes to activate the new guest additions.'; "
    end
    # Activate new kernel
    pkg_cmd << "shutdown -r +1; "
    config.vm.provision :shell, :inline => pkg_cmd
  end
end

