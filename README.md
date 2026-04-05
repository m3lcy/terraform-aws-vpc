# Terraform AWS Virtual Private Cloud (VPC)

A minimal, reusable Terraform module for creating an AWS VPC architecture with:

- public and private IPv4 subnets (segmenting mgmt/internal/guest)
- security groups for management, compute, internal, and guest
- route tables + gateways (IGW)
- Elastic IPs
- optional per-AZ NAT gateways
- outputs for all resources
- Flow logs (S3)

Coming soon:

- Flow logs (CloudWatch/S3)

---

## Architecture

### **Overview**
```mermaid
---
config:
  layout: elk
---
flowchart TB
  subgraph Repo ["Project Repository"]
    direction TB
    A[terraform-aws-vpc]
    A --> B[modules/vpc]
    A --> C[environments/dev]
    A --> D[environments/prod]
  end

subgraph VPC_Module ["VPC Module (modules/vpc)"]
    direction TB
    M1[VPC]
    M2[Subnets]
    M3[Route Tables - public/private]
    M4[Security Groups - mgmt/internal/guest/compute]
    M5[NAT Gateways]
    M6[Flow Logs]
    M7[(S3 Bucket)]
    M1 --> M2
    M2 --> M3
    M2 --> M4
    M3 --> M5
    M1 -->|captures traffic| M6
    M6 -->|ships to| M7
end

  subgraph Dev_Env ["Dev Environment"]
    direction TB
    E1[main.tf -> module.vpc]
    E2[terraform.tfvars - Local Vars]
    E3[terraform.tfstate - Local State]
    E1 -->|uses| M1
    E1 --> E2
    E1 --> E3
  end

  subgraph Prod_Env ["Prod Environment"]
    direction TB
    P1[main.tf -> module.vpc]
    P2[terraform.tfvars - Prod Vars]
    P3[backend.tf - Backend Config]
    P4[S3 State Bucket]
    P5[DynamoDB Lock Table]
    
    P1 -->|uses| M1
    P1 --> P2
    P1 --> P3
    P3 -->|manages| P4
    P4 --> P5
  end  
  M4 -.->|exports| O[Subnet IDs / SG IDs / RT IDs]
  E1 -.-> O
  P1 -.-> O
```

### **VPC Module**
```mermaid
---
config:
  layout: elk
---
flowchart TB
 subgraph VPC_Module["VPC Module (modules/vpc)"]
    direction TB
        M1["VPC"]
        M2["Subnets"]
        M3["Route Tables - public/private"]
        M4["Security Groups - mgmt/internal/guest/compute"]
        M5["NAT Gateways"]
        M6["Flow Logs"]
        M7[("S3 Bucket")]
  end
    M1 --> M2
    M2 --> M3 & M4
    M3 --> M5
    M1 -- captures traffic --> M6
    M6 -- ships to --> M7
    n1["Prod"] -- uses --> M1
    n2["Dev"] -- uses --> M1
    M4 L_M4_O_0@-- exports --> O["Subnet IDs / SG IDs / RT IDs"]

    n1@{ shape: rect}
    n2@{ shape: rect}

    L_M4_O_0@{ animation: fast }
```

### **Prod Environment**
```mermaid
---
config:
  layout: fixed
---
flowchart TB
 subgraph Prod_Env["Prod Environment"]
    direction TB
        P1["main.tf -> module.vpc"]
        P2["terraform.tfvars - Prod Vars"]
        P3["backend.tf - Backend Config"]
        P4["S3 State Bucket"]
        P5["DynamoDB Lock Table"]
  end
    P1 --> P3 & P2
    P4 --> P5
    P1 L_P1_O_0@-.-> O["Subnet IDs / SG IDs / RT IDs"]
    P1 -- uses --> n1["VPC Module"]
    P3 -- manages --> P4

    n1@{ shape: rect}

    L_P1_O_0@{ animation: fast }
```

### **Dev Environment**
```mermaid
---
config:
  layout: fixed
---
flowchart TB
 subgraph Dev_Env["Dev Environment"]
    direction TB
        E1["main.tf -> module.vpc"]
        E2["terraform.tfvars - Local Vars"]
        E3["terraform.tfstate - Local State"]
  end
    E1 --> E2
    E1 L_E1_n1_0@-. exports .-> n1["Subnet IDs / SG IDs / RT IDs"]
    E1 -- uses --> O["VPC Module"]
    E1 --> E3

    n1@{ shape: rect}

    L_E1_n1_0@{ animation: fast }
```

---

## Environments

### `environments/dev` 
- **State:** Local (`terraform.tfstate`)
- **Purpose:** Sandbox for rapid testing of VPC module changes.
- **Run:** `cd environments/dev && terraform init && terraform apply`

### `environments/prod` 
- **State:** Remote (AWS S3 + DynamoDB locking)
- **Purpose:** High-availability deployment across 3 Availability Zones.
- **Security:** Implements "Private by Default" architecture for Management and Internal tiers.

To run in prod:

```bash
cd environments/prod
terraform init
# terraform plan
```

NAT Gateway is disabled by default to avoid AWS charges, set `enable_nat_gateway = true` in `main.tf`

---

## Key Outputs

This module exposes useful outputs for downstream modules:

- `vpc_id`
- `subnet_ids`, `public_subnet_ids`, `private_subnet_ids`
- `subnet_ids_by_key` (e.g., `mgmt`, `internal`, `guest`)
- `public_route_table_id`
- `private_route_table_ids` (one per private subnet)
- `security_group_ids` (mgmt/compute/internal/guest)
- `nat_gateway_ids` / `nat_eip_ids` (one per AZ, when enabled)
- `flow_log_bucket_arn` / `flow_log_id`