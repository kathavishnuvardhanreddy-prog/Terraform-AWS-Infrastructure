resource "aws_instance" "jenkins" {
  ami           = "ami-040d34353aaf59871"
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  associate_public_ip_address = true

  tags = {
    Name = "terraform-jenkins-server"
  }
}
