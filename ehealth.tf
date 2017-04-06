provider "aws" {
  access_key = "AKIAJHMZAEFXLO7XUWSQ"
  secret_key = "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"
  region     = "eu-west-2"
}

resource "aws_instance" "elk" {
  ami           = "ami-ede2e889"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
      "sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'",
      "sudo apt-get update",
      "apt-cache policy docker-engine",
      "sudo apt-get install -y docker-engine==1.10",
    ]
  }

  provisioner "file" {
    source      = "elk/docker-compose.yml"
    destination = "docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose up",
    ]
  }
}
