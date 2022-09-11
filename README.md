# Terraform
---
Terraform enables you to safely and predictably create, change, and improve infrastructure. It is an open source tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.

## Codebase Structure
---
```
.
├── ansible
│   └── README.md
├── apps
│   └── devsetup
│       ├── datasources.tf
│       ├── main.tf
│       ├── Makefile
│       ├── outputs.tf
│       ├── providers.tf
│       ├── ssh.config.tpl
│       └── variables.tf
├── docs
│   ├── commands.md
│   ├── iam.md
│   ├── remotessh.md
│   ├── terraform.md
│   └── vscode.md
├── install
│   ├── terraform.install.sh
│   └── vscode.setup.sh
├── modules
│   ├── apps
│   │   ├── api-server
│   │   └── website
│   ├── common
│   │   ├── acm
│   │   └── user
│   ├── compute
│   │   └── ec2
│   │       └── ubuntu
│   │           ├── main.tf
│   │           ├── outputs.tf
│   │           └── variables.tf
│   ├── data
│   │   ├── efs
│   │   ├── rds
│   │   └── s3
│   └── networking
│       ├── alb
│       ├── front-proxy
│       ├── vpc
│       └── vpc-pairing
├── packer
├── README.md
├── scripts
│   ├── basic.sh
│   ├── crypter.js
│   ├── github.sh
│   ├── nginx.sh
│   ├── nodejs.sh
│   ├── ssh.config.tpl
│   └── tagrant.conf
├── tools
└── unstruct-projects
    ├── devsetup-public
    ├── hybrid-subnet
    └── loadbalancer
```
## Docs
---

### VS Code Setup
---

[vscode-extn-md](./docs/vscode.md)

### AWS IAM Setup
---

[aws-iam-md](./docs/iam.md)

### Terraform Setup
---

[terraform-setup-md](./docs/terraform.md)

### Remote SSH using VS Code
---

[remote-ssh-md](./docs/remotessh.md)

### Commands Used
---

[cmds-used-md](./docs/commands.md)

### Resources
---
- [Learn Terraform (and AWS) by Building a Dev Environment](https://www.youtube.com/watch?v=iRaai1IBlB0)

## TODO
---
- [ ] Investigate if AWS regions have their own CIDRs configured and restricted.
- [ ] Add loadbalancer example and try for both (with HTTPS and HTTP, HTTP should redirect to HTTPS)
- [ ] Structure Repo to handle more setups
- [ ] Also look into reusability of code - module + backend
- [ ] Go through any `AWS Certified Cloud Practitioner Training` course.
- [ ] Check ECS free tier and plan for a terraform file, bonus: EKS.
- [ ] Windows compute is to be documented and automated
