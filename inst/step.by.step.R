# pre step: installation of development kit
install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
# installing `devtools` installs also `usethis`

########################################
# R PACKAGE SECTION
# *
# Unzip the material in a local folder
# DO NOT CHOOSE A PATH WITH MORE THAN 250 CHARACTERS (do not use too many sub-folders)
# Create an RStudio project on the folder "myfinalpkg"
# * 
# Install latest renv package
install.packages("renv")

# *
# Activate renv project
renv::activate()
# *
# follow either a) or b), try a), if there are problems do b)
# ---
# a) utilize the renv project
# i.e the version used in the material to build myfinalpkg

# restore package dependencies from renv
renv::restore()
# You will be asked to activate the renv project, Y
# check if the status between installed packages and renv.lock is in sync
# dev = TRUE to include "Suggested" packages
renv::status(dev = TRUE)

# install devtools in the renv project
install.packages("devtools")

# snapshot the renv project including the packages in Suggests (development packages)
# this step should not be required
renv::snapshot(dev = TRUE)

# restore Suggested package dependencies from renv
renv::restore()

# ---
# b) reinitialise the renv project
renv::deactivate()
# delete the renv folder and the renv.lock file
renv::init(
  # use the DESCRIPTION file to capture dependencies (explicit)
  settings = list(snapshot.type = "explicit"),
)

# *
# install devtools in the renv project
install.packages("devtools")
# "roxygen2", "knitr", "testthat" should be already installed because suggested

# *
# Create a snapshot to track dependencies in the lockfile
renv::snapshot(dev = TRUE)

# --- end of b)

# *
# build and install the package in the project (myfinalpkg)
devtools::install()
# or from RStudio "Build" pane -> "Install"

# *
# test check the package
# devtools::test() # only unit tests
devtools::check() # for a complete check
# or from RStudio "Build" pane -> "Test" / "Build" pane -> "Check"

# *
# knit the Rmd example file to test if the package works correctly
knitr::knit("inst/rmarkdown_example/myfinalpkg_example.Rmd")
# or click on the "knit" button on the top of the RStudio UI, when opening the .Rmd file

########################################
# VERSION CONTROL SECTION

# *
# Initiate a local git repository
usethis::use_git() 
# --> do not commit; restart RStudio
# see that a new Git panel has been opened on top right, next to Build
# ON TERMINAL pane:
# set master branch on RStudio terminal panel:
# --> `git checkout -b master` 
# stage the files to be ready for commit:
# --> `git add .`    
# ---> refresh and check the Git pane
# commit them with an initial comment
# --> `git commit -m "initial commit"`   
# ---> refresh and check the Git pane
# the files are now committed to the Local Repository
# refresh the Git panel to see the master branch

# *
# connect to a GitHub account and repo, decide between public and private repo
# git config --global --list
# to check your Git username details on the RStudio terminal

# --> You may need to retrieve an auth token, if not done previously. 
# --> One-off usethis::create_github_token()

# *
# Perform either a) or b), if private is chosen then there will be fewer options on GitHub
# a)
# if part of an organisation you have on GitHub -->
usethis::use_github(organisation = "orgname", private = TRUE)
# example: usethis::use_github(organisation = "miraisolutions", private = FALSE)
# example: usethis::use_github(organisation = "guidomaggioorg", private = FALSE)
# b)
# if private repo, no organization -->
usethis::use_github(private = TRUE) # FALSE for a public repo
# url info's are added to DESCRIPTION file
# commit the DESCRIPTION file

# *
# push to repository
# check your GitHub repo, the page will open automatically
# the README file is the cover page of the repo

# ----------
# *
# Exercise, apply a change to README file

# enter the ### Installation section in the README file
# check on GitHub Repo XLConnect for an example
# (https://github.com/miraisolutions/xlconnect) " you may install XLConnect...."

# Add the R code in a section ```r (remove the # in front of the ```)
# ```r
require(remotes)
# Installs the master branch of myfinalpkg
remotes::install_github("yourgithubrepo/myfinalpkg")
# ```
# In the Git pane, check the diff, the new section appears in green
# test that you can build the package from the repo: 
remotes::install_github("yourgithubrepo/myfinalpkg")

# *
# Check the "diff" on RStudio 
# Commit to the local repo with a text message
# Push to the GitHUb repo
# Verify the changes in GitHub

########################################
# GITHUB ACTIONS SECTION

# *
# add CI workflow file from Mirai techguides
usethis::use_github_action(
  url = file.path("https://github.com/miraisolutions/techguides/blob/master",
                  "shiny-ci-cd/actions/ci-renv.yml"
  ),
  save_as = "workflow.yml"
)
# this creates a workflow.yml file in .github/workflows
# updates also the .Rbuildignore file

# add CI badge to read me
usethis::use_github_actions_badge(name = "workflow.yml")
# copy and paste the result into the Readme.md file
# be careful, make sure you have "yml"

# *
# knit README.Rmd (if .Rmd was created instead of .md)
# it requires installing the markdown package in the project, do install
# IF USING A VERSION DIFFERENT FROM 4.3.2
# - explicit R version, if not the same as in renv project:
#   - set to `R.Version()`, e.g. 4.2.1 in workflow.yml, matrix: config: r:
# - verify in Git Panel the file changes and additions
# - commit + push all modified/added files using a comment "Added CI"

# * 
# check the "Actions" page on your repository.

########################################
# GITFLOW SECTION let's do it together

# *
# create project board from "Projects" page
# select "Projects (classic)" -> New Project -> "Create Classic Project"
# enter a name and description
# choose "Automated Kanban with reviews" template
# link the repository "myfinalpkg"
# add collaborator (if any), from "Settings" page

# *
# create develop branch from master (Code page on GitHub)

# *
# add branches control Settings > Branches (requires public repository unless upgraded GitHub plan)
# do it for master and develop branches, set
# -- require a pull request before merging
# --- Require approvals
# -- require status checks to pass before merging
# --- Require branches to be up to date before merging
# --- Search for Status checks in the last week for this repository -> search "ubuntu-latest" -> select
# Click on Create
# Note , the rules do not work for a private repo without a paid plan

# *
# set develop as default branch (Settings page on GitHub, "branches", click on "switch" button)

# ------------
# Lets try a first issue: create a News.md file
# 
# - create NEWS.md
usethis::use_news_md()
#
# - Set the Package version as development version
usethis::use_dev_version()
# - Consolidate `NEWS.md`
# - Commit and push
# - GitHub Actions working?
# - Create a Pull Request from feature branch to `develop` branch, add reviewer (if possible)
# - Review, approve, merge


#------------
# * Issue 2
# do Issue 2, add plotly to the graphs

# create Issue 2, add plotly to the graphs, add it to project

# create feature branch for Issue one from develop: feature/2-add-plotly

# develop locally in RStudio, pull first and switch to the new branch
# Update the NEWS.md file, set version to development 9000 (if not there before)
# add the code at the end of bar_plot_data line_plot_data
pp <- p %>%
   ggplotly(tooltip = c("x", "y"))
pp
# update code (and DESCRIPTION), install plotly, 
usethis::use_package("plotly") # it will trigger installation of the package

# update roxygen tags (imports) and updated the NAMESPACE, 
roxygen2::roxygenise()
# # devtools::test(), it will fail, update the tests
# the following test for both plot functions should fail
expect_equal(class(pp), c("gg","ggplot"),
             label = "wrong plot class")
# Update the expectations of class(pp)

# the following test cannot work with plotly, to be removed / commented out
expect_equal(pp$data, data,
             label = "data are different from input")
# check the package: devtools::check()
# Update: renv (plotly to be added)
renv::status(dev = TRUE) # check the status
renv::snapshot(dev = TRUE) # override renv.lock

# commit and push to repo. 
# (Mention 'close #2' in the commit if you want an automated closure in the Project board. 

# Are the GitHub Actions CI passing?

# create a PR to merge from feature branch to develop and add a reviewer (if possible)
# approve and merge to develop

########################################
# * Release
# prepare a release
# if not on a new release branch, use develop branch

# consolidate Version in DESCRIPTION and NEWS
# commit with comment from NEWS.md

# create PR from develop to Master
# title: release number 1.1.0
# comment: paste the text from the NEWS.md
# get approval and merge to Master

# create a new release from GitHub
# choose tag: v1.1.0 -> target master
# release Title: myfinalpkg 1.1.0
# description: paste the text from the NEWS.md

# prepare for new release
# on develop, pull, add development version: usethis::use_dev_version()
# commit and push
