output "id" {
  value = aws_instance.this[*].id 
}

output "network_interface" {
  value = aws_instance.this[*].primary_network_interface_id
}