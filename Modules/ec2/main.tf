resource "aws_key_pair" "deployer_terra" {
  key_name = "deployer-terra-key"
  public_key = file("${path.module}/deployer_terra_key.pub")
}

resource "aws_security_group" "terra_security_g" {

  name        = "terra_security_g"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  # INGRESS RULE (Inbound Traffic)
  # This block allows all incoming traffic from any source
  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0                # All ports
    to_port     = 0                # All ports
    protocol    = "-1"             # All protocols (TCP, UDP, ICMP, etc.)
    cidr_blocks = ["0.0.0.0/0"]    # From any IPv4 address
  }

  # EGRESS RULE (Outbound Traffic)
  # This block allows all outgoing traffic to any destination
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0                # All ports
    to_port     = 0                # All ports
    protocol    = "-1"             # All protocols
    cidr_blocks = ["0.0.0.0/0"]    # To any IPv4 address
  }

  tags = {
    Name = "terra_security_g"
  }

}

resource "aws_instance" "server" {

  depends_on = [aws_security_group.terra_security_g , aws_key_pair.deployer_terra ]
  ami           = var.aws_ami_
  instance_type = var.aws_instance_type_
  user_data = file("${path.module}/start-up.sh")
  key_name = aws_key_pair.deployer_terra.key_name
  vpc_security_group_ids = [aws_security_group.terra_security_g.id]
  availability_zone = "ap-south-1a"
  subnet_id = var.subnet_id

  root_block_device {
    volume_size = 30 # Set the size of the root volume in GB
    volume_type = "gp2"
    delete_on_termination = true # delete on terminate the volume
    encrypted   = true # Encrypts the root volume
  }

  tags = {
    Name = "Automate_instance"
  }
}

resource "aws_ami_from_instance" "ami_server" {
  name               = "my-ami-s"
  source_instance_id = aws_instance.server.id
  depends_on = [aws_instance.server]
  tags = {
    Name = "my-ami-s"
  }
}