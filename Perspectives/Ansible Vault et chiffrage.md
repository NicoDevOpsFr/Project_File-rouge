# ANSIBLE VAULT
Pour augmenter la sécurité du déploiement et ajouter une étape d'identification dans le déploiement des docker-compose avec Ansible, il est envisagé d'utiliser **Ansible-Vault**.

A titre d'exemple, on peut l'appliquer au fichier __main.yml__ contenant les variables du projet.

```bash
ansible-vault encrypt main.yml
```
Le fichier main contenant les variables va etre chiffré.
```bash
ansible-playbook playbook.yml --ask-vault-pass
```
Pour déployer les docker-compose utilisant ces variables, il faudra renseigner un mot de passe.
```bash
ansible-playbook playbook.yml --vault-password-file /path/to/vault-password-file
```
On peut aussi via cette méthode utiliser une clé de déchiffrement stocké dans un fichier password.
La premiere méthode nécessite une intervention manuelle à chaque run du script mais elle plus sécurisé. La deuxieme facilite l'automatisation du déploiement mais nécessitera de restreindre l'acces au fichier mot de passe car il contiendra les mdp en clair.