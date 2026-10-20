# brvmr

Les données de la BRVM (cours, indices, dividendes) dans R, gratuitement.

Le package ne contient aucune donnée. Il lit le miroir public
[brvm-data-public](https://github.com/harzat/brvm-data-public) de
[BRVMetrics](https://brvmetrics.vercel.app).

## Installer

```r
install.packages("remotes")
remotes::install_github("harzat/brvmr")
```

## Utiliser

```r
library(brvmr)
brvm_actions()                      # les titres cotés
sonatel <- brvm_cours("SNTS")       # historique complet
brvm_cours("SNTS", depuis = "2025-01-01")
brvm_indices()                      # codes des indices
brvm_indice("BRVM30")
brvm_dividendes()                  # ajouter tout = TRUE pour toutes les colonnes
```

## À savoir

Les données de marché restent la propriété de leurs sources (BRVM,
SikaFinance, RicheBourse), sans garantie d'exactitude ni de fraîcheur.
Information seulement, pas un conseil en investissement. Pour un usage
commercial, voir les conditions de ces sources.

Conditions des sources vérifiées par l'auteur : (à compléter : URL et date).

Retrait ou question : https://brvmetrics.vercel.app/conditions
