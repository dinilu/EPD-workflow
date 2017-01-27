# Install RWordpress
#install_github(c("duncantl/XMLRPC", "duncantl/RWordPress"))
library(RWordPress)

# Set login parameters (replace admin,password and blog_url!)
options(WordpressLogin = c(dnietolugilde = 'g6yX:#!x'), WordpressURL = 'https://dnietolugilde.wordpress.com/xmlrpc.php')

# Include toc (comment out if not needed)
library(markdown)
options(markdown.HTML.options=c(markdownHTMLOptions(default=T), "toc"))

# Upload plots: set knitr options
library(knitr)

opts_knit$set(base.url="https://dl.dropboxusercontent.com/u/33940356/wordpress/epd-postgresql/", base.dir="")
, base.dir="D://Diego/Dropbox/Public/wordpress/EPD-PostgreSQL/")

# Post new entry to the wordpress blog and store the post id
knit2wp('vignettes/EPD-PostgreSQL.Rmd', title = 'Setting a PostgreSQL server for the European Pollen Database (EPD)', categories=c("EPDr"), mt_keywords=c("EPD", "PostgreSQL"), shortcode=TRUE, publish=TRUE)


