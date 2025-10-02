variable file_content{
    description = "the input of the file that will be inserted"
    type = map
    default = {
        statement1 = "Hello"
        statement2 = "Goodbye"
    }
}

resource "local_file" "file_content" {
  content  = var.file_content["statement1"]
  filename = "${path.module}/file_content"
}