variable "users" {                               
  type = "list"                                  
  default = ["abi", "arun", "anu"]      
}


variable "password_reset_required" {
  description = "Whether the user should be forced to reset the generated password on first login."
  default     = true
}

variable "pgp_key"{
  description = "password key"
  default = "dXNlcm5hbWU="

}                                                
