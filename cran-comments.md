## R CMD check results

# Initial submission (14/03/2023)

Environment :

- local windows R v4.2.2
- github action : ubuntu v22.04
- github action : windows server 2022 v10.0
- github action : macos v12.6.3
- check_rhub : Windows Server 2022, R-devel, 64 bit
- check_win_devel : Windows Server 2022 x64 (build 20348)

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Thomas Ferte <thomas.ferte@u-bordeaux.fr>'

New submission

Possibly misspelled words in DESCRIPTION:
  ESN (16:15)
  IdEx (23:75)
  PHDS (24:44)
  RRI (24:40)
  reservoirPy (13:72)

* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found

* checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

We believe the note is ok. The words are well spelled. The command 'tidy' note does not seem to be a problem (https://stackoverflow.com/questions/74857062/rhub-cran-check-keeps-giving-html-note-on-fedora-test-no-command-tidy-found). The detritus temp directory does not seem to be a problem (https://stackoverflow.com/questions/62456137/r-cran-check-detritus-in-temp-directory). 

# CRAN review (14/03/2023)

Please always write package names, software names and API (application
programming interface) names in single quotes in title and description.
e.g: --> 'python' , 'reservoirPy'
Please note that package names are case sensitive.

=> We changed the description file accordingly

If there are references describing the methods in your package, please
add these in the description field of your DESCRIPTION file in the form
authors (year) <doi:...>
authors (year) <arXiv:...>
authors (year, ISBN:...)
or if those are not available: <https:...>
with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for
auto-linking.
(If you want to add a title as well please put it in quotes: "Title")

=> We added the reference Trouvain et al. (2020) <doi:10.1007/978-3-030-61616-8_40>
in the description file.

Please add \value to .Rd files regarding exported methods and explain
the functions results in the documentation. Please write about the
structure of the output (class) and also what the output means. (If a
function does not return a value, please document that too, e.g.
\value{No return value, called for side effects} or similar)
Missing Rd-tags:
      createNode.Rd: \value
      install_reservoirpy.Rd: \value
      link.Rd: \value
      predict_seq.Rd: \value
      print.summary.reservoirR_fit.Rd: \value
      reservoirR_fit.Rd: \value

=> A value field was added to each of the functions listed above.

Please add small executable examples in your Rd-files to illustrate the
use of the exported function but also enable automatic testing.

=> An example was added below each function. Examples depending on python module reservoirpy are run conditionally.

Please do not modify the global environment (e.g. by using <<-) in your
functions. This is not allowed by the CRAN policies.
e.g.: R/zzz.R

=> TODO https://cran.r-project.org/web/packages/reticulate/vignettes/package.html

It is the same strategy used by the package autokeras for instance (see: https://github.com/r-tensorflow/autokeras/blob/master/R/package.R)

Please do not install packages in your functions, examples or vignette.
This can make the functions,examples and cran-check very slow. e.g.:
R/install.R

=> TODO It is the same strategy used by tensorflow package (https://github.com/rstudio/tensorflow/blob/main/R/install.R)

