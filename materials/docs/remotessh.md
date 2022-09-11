# Remote SSH using VS Code
---

### Generate SSH key pair
---
```bash
ssh-keygen -t ed25519
```
```
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/raktim/.ssh/id_ed25519): /home/raktim/.ssh/tagrant    
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/raktim/.ssh/tagrant
Your public key has been saved in /home/raktim/.ssh/tagrant.pub
The key fingerprint is:
SHA256:q71HtAD0S9ogiusA0qHuuKFVC+gh7SWPuOLxRS0rGXc mit@controller
The key's randomart image is:
+--[ED25519 256]--+
|     ..          |
|      ..         |
|  . . ..o        |
| * o ..=...      |
|B.*.o+.ESo .     |
|*+.B=.+  .o      |
|=++ooo  ..       |
|B+o o  o  .      |
|B= .  . oo       |
+----[SHA256]-----+
```

### VS Code Extension
---

![remote-ssh-logo](https://code.visualstudio.com/assets/docs/remote/ssh-tutorial/remote-ssh-extension.png)

```bash
code --list-extensions
```
```
...
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
```

### Current VS Code Window
---
```
View
Command Palette
Remote-SSH: Connect to Host ...
Choose Host IP
```

### New VS Code Window
---
- Remote Terminal
```
Terminal
New Terminal
```

- Remote Files
```
Explorer
Open Folder
/home/ubuntu/
OK
Trust the Authors
```
