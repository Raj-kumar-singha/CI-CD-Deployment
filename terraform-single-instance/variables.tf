variable "region"        { default = "ap-south-1" }
variable "instance_type" { default = "t3.micro" }
variable "key_name"      { description = "wezo-key.pem" }

# public GitHub repo that contains /backend and /frontend
variable "repo_url" {
  description = "Monorepo URL"
  default     = "https://github.com/Raj-kumar-singha/CI-CD-Deployment.git"
}

variable "sg_name" {
  description = "The name of the security group"
  type        = string
  default     = "ci-cd-sg"
}