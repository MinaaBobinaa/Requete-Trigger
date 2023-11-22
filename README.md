# INF3080-TP3

# test



## Pour faire n'importe quel modification:

Inserer au debut du code du modele physique:

```sql
DROP TABLE Adresse CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE Commande CASCADE CONSTRAINTS;
DROP TABLE Fournisseur CASCADE CONSTRAINTS;
DROP TABLE Produit CASCADE CONSTRAINTS;
DROP TABLE Prix_Produit CASCADE CONSTRAINTS;
DROP TABLE Produit_Fournisseur CASCADE CONSTRAINTS;
DROP TABLE Commande_Produit CASCADE CONSTRAINTS;
DROP TABLE Livraison CASCADE CONSTRAINTS;
DROP TABLE Livraison_Commande_Produit CASCADE CONSTRAINTS;
DROP TABLE Approvisionnement CASCADE CONSTRAINTS;
DROP TABLE Paiement CASCADE CONSTRAINTS;
```

Par la suite, faire les modifications et recreer les tables en les executant (peut supprimer les DROP)



- [ ] [Set up project integrations](https://gitlab.info.uqam.ca/naas.yasmine/inf3080-tp3/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing(SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

