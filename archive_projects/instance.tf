resource "aws_key_pair" "testkey" {
  key_name = "testkey"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_instance" "example" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  # VPC Subnet
  subnet_id = "${aws_subnet.main-public-1.id}"

  # Security Group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # Public SSH key
  key_name = "${aws_key_pair.testkey.key_name}"

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }
  connection {
    host = "${coalesce(self.public_ip, self.private_ip)}"
    type = "ssh"
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}