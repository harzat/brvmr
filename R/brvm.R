# Base du miroir public. Modifiable : options(brvmr.base = "...").
.brvm_base <- function() {
  getOption(
    "brvmr.base",
    "https://raw.githubusercontent.com/harzat/brvm-data-public/main"
  )
}

.brvm_msg_source <- function() {
  if (!isTRUE(getOption("brvmr.silencieux", FALSE))) {
    message("Source : BRVM, SikaFinance, RicheBourse via BRVMetrics. ",
            "Information seulement, sans garantie. Voir https://github.com/harzat/brvmr")
  }
}

.brvm_lire_texte <- function(chemin) {
  url <- paste0(.brvm_base(), "/", utils::URLencode(chemin))
  txt <- tryCatch(
    readLines(url, encoding = "UTF-8", warn = FALSE),
    error = function(e) {
      stop("Telechargement impossible : ", url, "\n", conditionMessage(e),
           call. = FALSE)
    }
  )
  txt[1] <- sub(paste0("^", intToUtf8(0xFEFF)), "", txt[1])
  txt
}

.brvm_nombre <- function(x) {
  espaces <- paste0("[[:space:]", intToUtf8(c(0x00A0, 0x202F)), "%]")
  x <- gsub(espaces, "", x)
  x <- sub(",", ".", x, fixed = TRUE)
  suppressWarnings(as.numeric(x))
}

.brvm_csv <- function(chemin) {
  txt <- .brvm_lire_texte(chemin)
  brut <- utils::read.csv2(
    text = txt, colClasses = "character", header = TRUE,
    check.names = FALSE, na.strings = c("", "NA")
  )
  noms <- c("date", "cloture", "plus_bas", "plus_haut", "ouverture",
            "volume_titres", "volume_fcfa", "variation_pct")
  if (ncol(brut) < length(noms)) {
    stop("Format inattendu pour ", chemin, call. = FALSE)
  }
  brut <- brut[, seq_along(noms), drop = FALSE]
  names(brut) <- noms
  out <- data.frame(
    date = as.Date(brut$date, format = "%d/%m/%Y"),
    stringsAsFactors = FALSE
  )
  for (n in noms[-1]) out[[n]] <- .brvm_nombre(brut[[n]])
  out <- out[order(out$date), , drop = FALSE]
  rownames(out) <- NULL
  out
}

#' Liste des titres cotés
#'
#' @return Un data.frame : ticker, nom, secteur, nom_officiel, csv.
#' @export
brvm_actions <- function() {
  j <- jsonlite::fromJSON(paste(.brvm_lire_texte("actions.json"), collapse = "\n"))
  a <- j$actions
  cols <- intersect(c("ticker", "nom", "secteur", "nom_officiel", "csv"), names(a))
  a[, cols, drop = FALSE]
}

#' Historique des cours d'un titre
#'
#' @param ticker Code du titre, par exemple "SNTS". Voir [brvm_actions()].
#' @param depuis Date de début optionnelle (objet Date ou "AAAA-MM-JJ").
#' @return Un data.frame trié par date : date, cloture, plus_bas, plus_haut,
#'   ouverture, volume_titres, volume_fcfa, variation_pct.
#' @export
brvm_cours <- function(ticker, depuis = NULL) {
  acts <- brvm_actions()
  i <- match(toupper(ticker), toupper(acts$ticker))
  if (is.na(i)) {
    stop("Titre inconnu : ", ticker, ". Voir brvm_actions().", call. = FALSE)
  }
  .brvm_msg_source()
  out <- .brvm_csv(paste0(acts$csv[i], ".csv"))
  if (!is.null(depuis)) out <- out[out$date >= as.Date(depuis), , drop = FALSE]
  out
}

#' Liste des indices disponibles
#'
#' @return Un vecteur de codes, par exemple "BRVM30", "BRVMC".
#' @export
brvm_indices <- function() {
  c("BRVM30", "BRVMAG", "BRVMAS", "BRVMC", "BRVMDI", "BRVMFI", "BRVMIN",
    "BRVMPA", "BRVMPR", "BRVMSP", "BRVMTR", "BRVM_CB", "BRVM_CD", "BRVM_EN",
    "BRVM_IN", "BRVM_SF", "BRVM_SP", "BRVM_TEL")
}

#' Historique d'un indice
#'
#' @param code Code de l'indice, voir [brvm_indices()].
#' @inheritParams brvm_cours
#' @return Un data.frame, même format que [brvm_cours()].
#' @export
brvm_indice <- function(code, depuis = NULL) {
  .brvm_msg_source()
  out <- .brvm_csv(paste0("indices/Indice_", code, ".csv"))
  if (!is.null(depuis)) out <- out[out$date >= as.Date(depuis), , drop = FALSE]
  out
}

#' Dividendes
#'
#' @param tout Si `TRUE`, renvoie toutes les colonnes (liens vers les avis,
#'   méthodes de calcul). Par défaut, seulement les colonnes utiles.
#' @return Un data.frame : ticker, societe, exercice, dividende, devise,
#'   dates d'annonce, de détachement et de paiement, dividende net, rendement.
#' @export
brvm_dividendes <- function(tout = FALSE) {
  .brvm_msg_source()
  j <- jsonlite::fromJSON(paste(.brvm_lire_texte("dividendes.json"), collapse = "\n"))
  d <- j[setdiff(names(j), "_meta")][[1]]
  if (isTRUE(tout)) return(d)
  utiles <- c("ticker", "societe", "exercice", "dividende", "devise",
              "date_annonce", "date_detachement", "date_paiement",
              "dividende_net", "rendement_pct", "source")
  d[, intersect(utiles, names(d)), drop = FALSE]
}
