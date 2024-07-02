library(devtools)
options(repos = c("CRAN" = "http://cran.us.r-project.org"))
options(Ncpus = parallel::detectCores())

# Set download method, to avoid the default behavior of using
# R's internal HTTP implementation, which doesn't support HTTPS connections.
# https://stackoverflow.com/questions/45061272/r-and-ssl-curl-on-ubuntu-linux-failed-ssl-connect-in-r-but-works-in-curl
options(download.file.method = "libcurl")

# Install the lightGBM installer package
install_github("Laurae2/lgbdl")
lgbdl::lgb.dl(compiler = "gcc", commit = "tags/v2.3.1")

install_github("dgrtwo/widyr")
install_github("ellisp/forecastxgb-r-package/pkg")
install_github("rstudio/leaflet")
# install_github fails for catboost.
# Following direct installation instructions instead: https://tech.yandex.com/catboost/doc/dg/installation/r-installation-binary-installation-docpage/
install_url('https://github.com/catboost/catboost/releases/download/v0.23.2/catboost-R-Linux-0.23.2.tgz', INSTALL_opts = c("--no-multiarch"))
install_github("sassalley/hexmapr")
install_github("hadley/multidplyr")
install_github("dselivanov/LSHR")

# install latest sparklyr and Spark (for local mode)
install_github("rstudio/sparklyr")
sparklyr::spark_install()

install.packages("genderdata", repos = "http://packages.ropensci.org")

install.packages("openNLPmodels.en",
                 repos = "http://datacube.wu.ac.at/",
                 type = "source")

install_github("davpinto/fastknn")
install_github("mukul13/rword2vec")

# b/232137539 Removed from RCRAN but required for Neurohacking in R coursera course
install_github("muschellij2/neurobase")
install_github("muschellij2/fslr")

# These signal processing libraries are on CRAN, but they require apt-get dependences that are
# handled in this image's Dockerfile.
install.packages("fftw")

# https://github.com/Kaggle/docker-rstats/issues/74
install_github("thomasp85/patchwork")

# https://github.com/Kaggle/docker-rstats/issues/73
install.packages("topicmodels")

install.packages("tesseract")

# Try to reinstall igraph and imager her until fixed in rcran.
install.packages("igraph")
install.packages("imager")

# Torch: install the full package upfront otherwise it will be installed on loading the package which doesn't work for kernels
# without internet (competitions for example).
install.packages("torch")
library(torch)
install_torch()

install.packages(c('collections', 'languageserver'), dependencies=TRUE)

# The tfhub package is added to the rcran image.
library(tfhub)
install_tfhub()


# This cluster validity index package is on CRAN.
install.packages("UniversalCVI")
