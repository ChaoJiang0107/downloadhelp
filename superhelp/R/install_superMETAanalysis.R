#' @title Install superMETAanalysis Package
#'
#' @description
#' Installs the superMETAanalysis R package from a private GitHub repository.
#' Handles OS-specific installation (Windows/macOS), requires GitHub authentication token.
#'
#' @param token \code{character} GitHub Personal Access Token (PAT) for
#'              authenticating access to private repositories.
#'
#' @return Invisible. No return value, called for side effects (package installation).
#' @export
#'
#' @examples
#' \dontrun{
#' install_superMETAanalysis(token = "ghp_yourActualTokenHere")
#' }
install_superMETAanalysis <- function (token)
{
    e <- tryCatch(detach("package:superMETAanalysis", unload = TRUE),
                  error = function(e) "e")
    (td <- tempdir(check = TRUE))
    td2 <- "1"
    while (td2 %in% list.files(path = td)) {
        td2 <- as.character(as.numeric(td2) + 1)
    }
    (dest <- paste0(td, "/", td2))
    do::formal_dir(dest)
    dir.create(path = dest, recursive = TRUE, showWarnings = FALSE)
    (tf <- paste0(dest, "/superMETAanalysis.zip"))
    if (do::is.windows()) {
        download.file(url = "https://github.com/ChaoJiang0107/superRpackage/superMETAanalysis_win/zip/refs/heads/main",
                      destfile = tf, mode = "wb", headers = c(NULL, Authorization = sprintf("token %s",
                                                                                            token)))
        unzip(zipfile = tf, exdir = dest, overwrite = TRUE)
    }
    else {
        download.file(url = "https://github.com/ChaoJiang0107/superRpackage/superMETAanalysis_mac/zip/refs/heads/main",
                      destfile = tf, mode = "wb", headers = c(NULL, Authorization = sprintf("token %s",
                                                                                            token)))
        unzip(zipfile = tf, exdir = dest, overwrite = TRUE)
    }
    if (do::is.windows()) {
        main <- paste0(dest, "/superMETAanalysis_win-main")
        (superMETAanalysis <- list.files(main, "superMETAanalysis_", full.names = TRUE))
        (superMETAanalysis <- superMETAanalysis[do::right(superMETAanalysis, 3) == "zip"])
        (k <- which.max(as.numeric(do::Replace0(superMETAanalysis, ".*superMETAanalysis_",
                                                "\\.zip", "\\.tgz", "\\."))))
        unzip(superMETAanalysis[k], files = "superMETAanalysis/DESCRIPTION", exdir = main)
    }
    else {
        main <- paste0(dest, "/superMETAanalysis_mac-main")
        superMETAanalysis <- list.files(main, "superMETAanalysis_", full.names = TRUE)
        superMETAanalysis <- superMETAanalysis[do::right(superMETAanalysis, 3) == "tgz"]
        k <- which.max(as.numeric(do::Replace0(superMETAanalysis, ".*superMETAanalysis_",
                                               "\\.zip", "\\.tgz", "\\.")))
        untar(superMETAanalysis[k], files = "superMETAanalysis/DESCRIPTION", exdir = main)
    }
    (desc <- paste0(main, "/superMETAanalysis"))
    check_package(desc)
    install.packages(pkgs = superMETAanalysis[k], repos = NULL, quiet = FALSE)
    message("Done(superMETAanalysis)")
    x <- suppressWarnings(file.remove(list.files(dest, recursive = TRUE,
                                                 full.names = TRUE)))
    invisible()
}
