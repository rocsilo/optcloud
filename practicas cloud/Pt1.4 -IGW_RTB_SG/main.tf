

# --!Si el chat me ha dado una pequeña ayudita 😉😉😉 però esta todo entendido a la perfeción!--

# Configuración de Terraform y proveedor
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Especifica de dónde descargar el proveedor AWS
      version = "~> 5.0"         # Usa la versión 5.x del proveedor AWS
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Define la región de AWS donde se desplegarán los recursos
}

# Crear VPC (Virtual Private Cloud)
resource "aws_vpc" "vpc_03" {
  cidr_block           = "10.0.0.0/16"  # Define el rango de IPs de la VPC (65,536 IPs)
  enable_dns_hostnames = true           # Permite asignar nombres DNS a las instancias
  enable_dns_support   = true           # Habilita resolución DNS dentro de la VPC

  tags = {
    Name = "VPC-03"  # Etiqueta para identificar la VPC en la consola AWS
  }
}

# Crear Internet Gateway
resource "aws_internet_gateway" "igw" {  # CORREGIDO: Cambiado de ig_main a igw
  vpc_id = aws_vpc.vpc_03.id  # Asocia el Internet Gateway a la VPC creada

  tags = {
    Name = "IGW-VPC-03"  # Etiqueta identificativa
  }
}

# Crear subred pública A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc_03.id  # Asocia la subred a la VPC
  cidr_block              = "10.0.1.0/24"      # Rango de 256 IPs para esta subred
  availability_zone       = "us-east-1a"       # Zona de disponibilidad específica
  map_public_ip_on_launch = true               # Asigna IP pública automáticamente a las instancias

  tags = {
    Name = "Public-Subnet-A"  # Etiqueta para identificar la subred
  }
}

# Crear subred pública B
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc_03.id  # Asocia la subred a la VPC
  cidr_block              = "10.0.2.0/24"      # Rango de 256 IPs para esta subred
  availability_zone       = "us-east-1b"       # Zona de disponibilidad diferente
  map_public_ip_on_launch = true               # Asigna IP pública automáticamente

  tags = {
    Name = "Public-Subnet-B"  # Etiqueta para identificar la subred
  }
}

# Crear tabla de rutas pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_03.id  # Asocia la tabla de rutas a la VPC

  route {
    cidr_block = "0.0.0.0/0"     # Ruta por defecto (todo el tráfico)
    gateway_id = aws_internet_gateway.igw.id  # CORREGIDO: Usa igw en lugar de ig_main
  }

  tags = {
    Name = "Public-Route-Table"  # Etiqueta identificativa
  }
}

# Asociar tabla de rutas con subred A
resource "aws_route_table_association" "public_rt_assoc_a" {
  subnet_id      = aws_subnet.public_subnet_a.id  # Subred a asociar
  route_table_id = aws_route_table.public_rt.id   # Tabla de rutas a aplicar
}

# Asociar tabla de rutas con subred B
resource "aws_route_table_association" "public_rt_assoc_b" {
  subnet_id      = aws_subnet.public_subnet_b.id  # Subred a asociar
  route_table_id = aws_route_table.public_rt.id   # Tabla de rutas a aplicar
}

# Crear grupo de seguridad
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"    # Nombre del grupo de seguridad
  description = "Security group for EC2 instances"  # Descripción
  vpc_id      = aws_vpc.vpc_03.id       # Asocia el grupo a la VPC

  # Regla SSH desde cualquier lugar
  ingress {
    from_port   = 22                    # Puerto SSH
    to_port     = 22                    # Puerto SSH
    protocol    = "tcp"                 # Protocolo TCP
    cidr_blocks = ["0.0.0.0/0"]         # Permite desde cualquier IP
    description = "SSH access from anywhere"
  }

  # Regla ICMP solo desde dentro de la VPC
  ingress {
    from_port   = -1                    # -1 significa todos los puertos ICMP
    to_port     = -1                    # -1 significa todos los puertos ICMP
    protocol    = "icmp"                # Protocolo ICMP (ping)
    cidr_blocks = ["10.0.0.0/16"]       # Solo desde IPs de la VPC
    description = "ICMP from within VPC"
  }

  # Permitir todo el tráfico saliente
  egress {
    from_port   = 0                     # Puerto inicial
    to_port     = 0                     # Puerto final
    protocol    = "-1"                  # -1 significa todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]         # Hacia cualquier destino
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "EC2-Security-Group"  # Etiqueta identificativa
  }
}

# Crear instancia EC2 en subred A
resource "aws_instance" "ec2_a" {
  ami                    = "ami-0c02fb55956c7d316"  # AMI de Amazon Linux 2023
  instance_type          = "t3.micro"               # Tipo de instancia (máquina pequeña)
  subnet_id              = aws_subnet.public_subnet_a.id  # Subred donde se desplegará
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # Grupo de seguridad aplicado
  key_name               = "vockey"                 # Key pair para conexión SSH

  tags = {
    Name = "ec2-a"  # Etiqueta para identificar la instancia
  }
}

# Crear instancia EC2 en subred B
resource "aws_instance" "ec2_b" {
  ami                    = "ami-0c02fb55956c7d316"  # Mismo AMI para consistencia
  instance_type          = "t3.micro"               # Mismo tipo de instancia
  subnet_id              = aws_subnet.public_subnet_b.id  # Subred diferente
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # Mismo grupo de seguridad
  key_name               = "vockey"                 # Mismo key pair

  tags = {
    Name = "ec2-b"  # Etiqueta diferente para identificar
  }
}

# Outputs - Información que se mostrará después del despliegue
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.vpc_03.id  # Muestra el ID de la VPC
}

output "subnet_a_id" {
  description = "ID de la Public Subnet A"
  value       = aws_subnet.public_subnet_a.id  # Muestra el ID de la subred A
}

output "subnet_b_id" {
  description = "ID de la Public Subnet B"
  value       = aws_subnet.public_subnet_b.id  # Muestra el ID de la subred B
}

output "ec2_a_public_ip" {
  description = "IP pública de la instancia ec2-a"
  value       = aws_instance.ec2_a.public_ip  # Muestra la IP pública de ec2-a
}

output "ec2_b_public_ip" {
  description = "IP pública de la instancia ec2-b"
  value       = aws_instance.ec2_b.public_ip  # Muestra la IP pública de ec2-b
}

output "security_group_id" {
  description = "ID del grupo de seguridad"
  value       = aws_security_group.ec2_sg.id  # Muestra el ID del grupo de seguridad
}