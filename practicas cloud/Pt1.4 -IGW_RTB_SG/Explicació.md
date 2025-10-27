🚀 Resum de la Infraestructura AWS
🏗️ Arquitectura Bàsica

    Regió: us-east-1

    2 Zones: A i B

    VPC: 10.0.0.0/16

📡 Subxarxes Públiques

    Subnet A: 10.0.1.0/24 (us-east-1a) → ec2-a

    Subnet B: 10.0.2.0/24 (us-east-1b) → ec2-b

🖥️ Instàncies EC2

    2 servidores t3.micro amb Amazon Linux

    Cada uno en una zona diferente para alta disponibilidad

    Key pair: vockey

🔐 Seguretat

    SSH: Desde cualquier lugar

    ICMP: Solo dentro de la VPC

    Saliente: Todo permitido

🌐 Conectividad

    Internet Gateway para acceso público

    IPs públicas automáticas

    Comunicación interna entre instancias

