variable "region"        { default = "ap-south-1" }
variable "instance_type" { default = "t3.micro" }
variable "key_name"      { description = "Your existing EC2 key pair name" }

# public GitHub repo that contains /backend and /frontend
variable "repo_url" {
  description = "Monorepo URL"
  default     = "https://github.com/Raj-kumar-singha/CI-CD-Deployment.git"
}
