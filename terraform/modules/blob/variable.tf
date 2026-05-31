variable "storageaccountname" {}
variable "containername" {}
variable "containeraccess" {}
variable "blobtype" {}
variable "blobname" {}
variable "site_path" {}
variable "storage_account_id" {}

variable "mime_types" {
  description = "Mapping of file extensions to MIME types"
  type        = map(string)
  default = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".json" = "application/json"
    ".xml"  = "application/xml"
    ".txt"  = "text/plain"
  }
}