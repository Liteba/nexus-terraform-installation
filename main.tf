resource "aws_instance" "nexus_server" {
  ami           = "ami-07fb9d5c721566c65"
  instance_type = "t2.medium"
  key_name      = "realmen12345"
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo hostnamectl set-hostname nexus

    sudo useradd nexus
    sudo echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus
    sudo su - nexus << EOT
      cd /opt
      sudo yum install wget git nano unzip -y
      sudo yum install java-11-openjdk-devel java-1.8.0-openjdk-devel -y

      sudo wget http://download.sonatype.com/nexus/3/nexus-3.15.2-01-unix.tar.gz
      sudo tar -zxvf nexus-3.15.2-01-unix.tar.gz
      sudo mv /opt/nexus-3.15.2-01 /opt/nexus
      sudo rm -rf nexus-3.15.2-01-unix.tar.gz

      sudo chown -R nexus:nexus /opt/nexus
      sudo chown -R nexus:nexus /opt/sonatype-work
      sudo chmod -R 775 /opt/nexus
      sudo chmod -R 775 /opt/sonatype-work

      sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus

      sudo systemctl enable nexus
      sudo systemctl start nexus
      sudo systemctl status nexus
      echo "end of nexus installation"
    EOT
  EOF

  tags = {
    Name = "nexus"
  }
}
