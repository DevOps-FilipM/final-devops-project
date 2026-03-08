# Klucz SSH do EC2
resource "aws_key_pair" "devops_key" {
  key_name   = var.ssh_key_name
  public_key = file("~/.ssh/id_ed25519.pub")

  tags = {
    Name        = "${var.project_name}-key"
    Environment = var.environment
  }
}

# Najnowszy Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Instancja EC2
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app_server.id]
  key_name               = aws_key_pair.devops_key.key_name
  root_block_device {
	volume_size = 20
	volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    # Aktualizacja systemu
    yum update -y

    # Instalacja Dockera
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    # Instalacja Docker Compose
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # Pobranie i uruchomienie aplikacji
    docker pull ${var.docker_image}
    docker run -d \
      --name todo-app \
      --restart always \
      -p 3000:3000 \
      ${var.docker_image}

    # Instalacja Node Exporter (metryki systemowe dla Prometheusa)
    useradd --no-create-home --shell /bin/false node_exporter
    wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
    tar xvf node_exporter-1.7.0.linux-amd64.tar.gz
    cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
    chown node_exporter:node_exporter /usr/local/bin/node_exporter

    # Uruchomienie Node Exporter jako serwis
    cat > /etc/systemd/system/node_exporter.service << 'SERVICE'
    [Unit]
    Description=Node Exporter
    After=network.target

    [Service]
    User=node_exporter
    ExecStart=/usr/local/bin/node_exporter

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl start node_exporter
    systemctl enable node_exporter
  EOF

  tags = {
    Name        = "${var.project_name}-server"
    Environment = var.environment
  }
}
