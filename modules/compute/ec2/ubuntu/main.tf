resource "aws_instance" "tagrant" {
  count = var.instance_count

  ami           = var.aws_ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.vpc_security_group_ids

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
    encrypted             = false

    tags = {
      Description = "tagrant ebs volume"
    }
  }

  provisioner "local-exec" {
    command = templatefile("../../scripts/ssh.config.tpl", {
      hostname     = self.public_ip, #self.private_ip
      user         = "${var.instance_user}",
      identityfile = "${var.ssh_private_key}"
      }
    )
    interpreter = ["bash", "-c"]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip #self.private_ip
    user        = "${var.instance_user}"
    private_key = file("${var.ssh_private_key}")
  }

  provisioner "file" {
    source      = "../../scripts/"
    destination = "/tmp"
  }

  /*
  provisioner "remote-exec" {
    inline = [
      "bash /tmp/basic.sh \"${var.aws_env}\"",
      "bash /tmp/nodejs.sh",
      "bash /tmp/nginx.sh",
    ]
  }
  */

  tags = {
    Terraform   = "true"
    Project     = var.project_name
    Environment = var.environment
  }
}
