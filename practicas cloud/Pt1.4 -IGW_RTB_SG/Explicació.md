-------------------------------------RESUMEN DE LA INFRASTRUCTURA-----------------------------------------------#
🏗️ Arquitectura Bàsica

    Regió: us-east-1

    2 Zones: A i B

    VPC: 10.0.0.0/16

    Internet Gateway: Connexió a Internet per a totes les subxarxes públiques

    Taula de Rutes Pública: Direcciona tot el trànsit (0.0.0.0/0) cap a l'Internet Gateway

📡 Subxarxes Públiques

    Subnet A: 10.0.1.0/24 (us-east-1a) → ec2-a

    Subnet B: 10.0.2.0/24 (us-east-1b) → ec2-b

    Assignació automàtica d'IPs públiques: Activat per a ambdues subxarxes

    Associació a taula de rutes: Ambdues subxarxes vinculades a la mateixa taula de rutes pública

🖥️ Instàncies EC2

    2 servidors t3.micro amb Amazon Linux 2023 AMI

    ec2-a: Desplegat a Public Subnet A (us-east-1a)

    ec2-b: Desplegat a Public Subnet B (us-east-1b)

    Alta disponibilitat: Instàncies distribuïdes en zones diferents

    Key pair: vockey per a connexions SSH

    Etiquetatge: ec2-a i ec2-b per a fàcil identificació

🔐 SEGURETAT - REGLES DEL GRUP DE SEGURETAT
🟢 REGLES D'ACCÉS ENTRANT (INGRESS):

📍 PORT 22 - SSH:

    Protocol: TCP

    Port: 22

    Origen: 0.0.0.0/0 (QUALSEVOL LLOC)

    Propòsit: Accés remot SSH des de qualsevol ubicació

📍 PROTOCOL ICMP - PING:

    Protocol: ICMP

    Ports: Tots (-1)

    Origen: 10.0.0.0/16 (NOMÉS DINS LA VPC)

    Propòsit: Permetre ping només entre instàncies de la mateixa VPC

🟢 REGLES DE SORTIDA (EGRESS):

📍 TOUT EL TRÀNSIT SORTINT:

    Protocol: Tots (-1)

    Ports: Tots (0-0)

    Destí: 0.0.0.0/0 (QUALSEVOL LLOC)

    Propòsit: Permetre que les instàncies accedeixin a Internet i altres serveis

🌐 Conectividad y Xarxa

    Internet Gateway: Proporciona accés a Internet per a les subxarxes públiques

    IPs públiques automàtiques: Assignades a les instàncies en el llançament

    Comunicació interna: Les instàncies poden comunicar-se entre si dins la VPC

    Resolució DNS: Activada per a la VPC i els noms d'hoste

🔄 FLUX DE TRÀNSIT CONFIGURAT

➡️ ENTRADA:

    SSH (Port 22) → Permès des de qualsevol IP

    ICMP (Ping) → Permès només des de 10.0.0.0/16

⬅️ SORTIDA:

    Tot el trànsit → Permès cap a qualsevol destinació

🔄 INTERN:

    Comunicació entre ec2-a i ec2-b → Permesa via adreces privades

