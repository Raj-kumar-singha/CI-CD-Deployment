resource "aws_instance" "ci_cd_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Example Ubuntu AMI (change based on region)
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = templatefile("${path.module}/user_data_single.tpl", {
    backend_port  = 5000
    frontend_port = 3000
    jenkins_port  = 8080
  })

  tags = {
    Name = "ci-cd-instance"
  }
}
