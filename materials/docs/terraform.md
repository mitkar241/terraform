# Terraform Setup
---

### Terraform Installation
---
```bash
bash scripts/terraform.install.sh
```

### VS Code Extension
---

[Terraform - Anton Kulikov](https://marketplace.visualstudio.com/items?itemName=4ops.terraform)

```bash
code --list-extensions
```
```
4ops.terraform
...
```

### Variables
---
- provide vars as `-var="host_os=ubuntu"`

### Console
---
```bash
terraform console
> var.host_os
(known after apply)
> exit
```
