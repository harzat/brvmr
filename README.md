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

Ce package ne contient aucune donnée : il lit le miroir public de BRVMetrics.
Au 21 octobre 2026, aucune de ces sources ne publie de licence de
réutilisation (pas de licence ouverte). Les données sont donc fournies à titre
d'information, sans autorisation écrite des sources. Si une source demande le
retrait de ses données, elles seront retirées du miroir et ce package cessera
d'y accéder.

Retrait ou question : https://brvmetrics.vercel.app/conditions
