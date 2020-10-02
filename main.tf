provider "aws" {
	region = "us-east-1"
}

resource "aws_instance" "jenkins" {
	ami = "ami-0947d2ba12ee1ff75"
	instance_type = "t2.micro"
    key_name = "terraform"
    availability_zone = "us-east-1c"
	user_data = file("install_jenkins.sh")
	tags = {
		Name = "Jenkins"	
	}
}
