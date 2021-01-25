variable "vpc_a"{
   type   = string 
   description = "VPC_A_ID"
   default = "vpc-0a058f092f2261e15"
}


variable "vpc_b"{
   type = string
   description = "VPC_B_ID"
   default = "vpc-076a0943f42458117"
}

variable "region"{
   type = string
   description = "aws region"
   default = "eu-west-3"
}

variable "type_instance"{
   type = string 
   default = "t3.micro"
}

variable "key_ssh"{
   type = string
   default = "tp_infra_ynov"
}
