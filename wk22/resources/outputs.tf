# --VPC Resources Outputs Child Module--

# output of VPC Id
output "vpc_id" {
  value = aws_vpc.wk22_vpc.id
}

#output "private_rt_id" {
#  value = aws_route_table.private_rt.id
#}

#output "public_rt_id" {
#  value = aws_route_table.public_rt.id
#}

#output "igw_id" {
#  value = aws_internet_gateway.igw.id
#}

#output "nat_gateway_id" {
#  value = aws_nat_gateway.nat_gateway.id
#}