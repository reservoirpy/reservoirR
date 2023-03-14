## R CMD check results

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
