variable "nginx_ami" {
  type = "string"
  //default = "ami-cd0f5cb6"
  //default = "ami-d3ae53a9"
  //default = "ami-f4906c8e"
  default = "ami-49699733"
}
variable "keypair" {
  type = "map"

  default = {
    key_name = "nginx_rsa"
    public_key = "../sshkeys/ustglobal_rsa.pub"
	private_key = "../sshkeys/ustglobal_rsa.pem"
  }
}

