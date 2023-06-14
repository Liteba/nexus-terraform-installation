output "public_ip" {
  value = aws_instance.nexus_server.public_ip 
  description = "ec2 instance public-ip"
}