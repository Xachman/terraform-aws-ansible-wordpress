resource "aws_instance" "wordpress" {
    ami                 = "ami-0ca5c3bd5a268e7db"
    instance_type       = "t2.micro"
    availability_zone   = "us-west-2c"
    subnet_id           = local.subnet_id
    vpc_security_group_ids     = [
        local.security_group
    ]
    key_name            = local.key_name
    tags                = {
        Name = "wordpress"
    }
    provisioner "remote-exec" {
      inline = ["echo hello"]

      connection {
        host        = self.public_ip
        type        = "ssh"
        user        = "ubuntu"
        private_key = file(local.ssh_key_private)
      }
    }
    provisioner "local-exec" {
      command = "ansible-playbook -i '${self.public_ip},' --private-key ${local.ssh_key_private} provision.yml --extra-vars 'mysql_password=${local.mysql_password}'"
    }
    root_block_device {
        volume_size = "10"
        tags = {
            Name = "instance1"
        }
    }
}