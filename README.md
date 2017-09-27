Utilisation 
===========
* Installer le client azure
* Installer terraform
* Mettre en place un groupe de resssource et un réseau virtuel
* Mettre à jour le fichier variables.tf pour renseigner le nom et l'identifiant du sous réseau
* Se connecter à azure : 
```
az login
```
* Vérifier la création :
```
terraform plan -var 'app={sshcert="ssh-rsa ..."}'
```
* Executer le script : 
```
terraform apply -var 'app={sshcert="ssh-rsa ..."}'
```

Obtenir des informations sur la vm
===
* Executer les commandes suivantes : 
```
terraform refresh
terraform output
```

Destruction des ressources
==============
```
terraform destroy
```





