#To get one static IP for NAT Gateway

resource "aws_eip" "Elastic_ip" {
	vpc	= true
}

#To create NAT Gateway 
resource "aws_nat_gateway" "NAT" {
	allocation_id	= "${aws_eip.Elastic_ip.id}"
	subnet_id	= "${aws_subnet.public.id}"
	tags = {
		Name = "NAT-GATEWAY"
	}
	depends_on	= [aws_internet_gateway.abhiigw]
}

#To create routing table for NAT Gateway
resource "aws_route_table" "NAT_R_TABLE" {
	vpc_id	= "${aws_vpc.create_vpc.id}"
	route {
		cidr_block	= "0.0.0.0/0"
		nat_gateway_id	= "${aws_nat_gateway.NAT.id}"
	}
	tags = {
		Name = "ROUTETABLEFORNAT"
	}
}


#To associate it with subnet
resource "aws_route_table_association" "NAT_TABLE_ASSOCIATE" {
	subnet_id	= "${aws_subnet.private.id}"
	route_table_id	= "${aws_route_table.NAT_R_TABLE.id}"
}
