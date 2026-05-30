# このプロジェクト専用の renv ライブラリを使う
dir.create("renv/library", recursive = TRUE, showWarnings = FALSE)
project_library <- normalizePath("renv/library", mustWork = FALSE)
Sys.setenv(
  RENV_PATHS_LIBRARY = project_library,
  RENV_PATHS_LIBRARY_ROOT = project_library
)
.libPaths(c(project_library, .libPaths()))

# renv の確認メッセージを出さずに使えるようにする
options(renv.consent = TRUE)
options(repos = c(CRAN = "https://cloud.r-project.org"))

# まず renv 自体が使えるか確認する
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", lib = project_library)
}

library(renv)

# このプロジェクトの renv 環境を有効にする
renv::activate(project = getwd())

# 必要なパッケージだけ、入っていない場合にインストールする
ensure_package <- function(package, remote = package) {
  if (!requireNamespace(package, quietly = TRUE)) {
    renv::install(remote)
  }
}

required_packages <- c(
  "renv",
  "rmarkdown",
  "knitr",
  "remotes",
  "WDI",
  "rio",
  "tidyverse",
  "countrycode",
  "Hmisc",
  "data.table",
  "plm",
  "fixest",
  "etwfe",
  "synthdid",
  "mice",
  "survival",
  "lubridate",
  "modelsummary",
  "kableExtra",
  "doBy",
  "gridExtra",
  "sf",
  "rnaturalearth",
  "rnaturalearthdata",
  "Cairo",
  "magick",
  "ggsurvfit",
  "gtsummary",
  "tidycmprsk",
  "tibble",
  "tinytex",
  "HonestDiD"
)

# R Markdown の実行に必要な基本パッケージ
ensure_package("rmarkdown")
ensure_package("knitr")
ensure_package("remotes")

# データ取得・入出力
ensure_package("WDI")
ensure_package("rio")

# データ操作
ensure_package("tidyverse")
ensure_package("countrycode")
ensure_package("Hmisc")
ensure_package("data.table")
ensure_package("plm")

# 推定
ensure_package("fixest")
ensure_package("etwfe")
ensure_package("synthdid")
ensure_package("mice")
ensure_package("survival")
ensure_package("lubridate")

# 図表出力
ensure_package("modelsummary")
ensure_package("kableExtra")
ensure_package("doBy")
ensure_package("gridExtra")
ensure_package("sf")
ensure_package("rnaturalearth")
ensure_package("rnaturalearthdata")
ensure_package("Cairo")
ensure_package("magick")
ensure_package("ggsurvfit")
ensure_package("gtsummary")
ensure_package("tidycmprsk")
ensure_package("tibble")
ensure_package("tinytex")

# GitHub 版が必要なパッケージ
ensure_package("HonestDiD", "asheshrambachan/HonestDiD")

# rio が追加形式のファイルも読めるようにする
if (requireNamespace("rio", quietly = TRUE)) {
  rio::install_formats()
}

# 最後に、現在の依存関係をまとめて renv.lock に保存する
renv::snapshot(packages = required_packages, prompt = FALSE)
