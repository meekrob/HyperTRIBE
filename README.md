# Numerous implementation issues on Mac OS X
HyperTRIBE relies on a mysql database to do execute its pipeline. This is unworkable in a user environment, so here are some things I had to do to get it to work on Mac OS X. *You will need the administrative password on your Mac.*

- Verify perl version is 5.28, upgrade if necessary. Make sure you PATH variable reflects the new install bin.
- Install mysql if necessary.
  - Allow security block on LOCAL INTABLE. This is necessary to **load an entire sam file into a database** efficiently.
  - (How to set host settings on the security block). (How to set client settings on security block).
  - I have changed the table schemas to include default INTs, this improves speed to 2x.
- What else do we need to do?

# HyperTRIBE
HyperTRIBE is a technique used for the identification of the targets of RNA binding proteins (RBP) in vivo. This is an improved version of a previously developed technique called TRIBE (Targets of RNA-binding proteins Identified By Editing).

Please get the code from GitHub or download from here: [![DOI](https://zenodo.org/badge/114820120.svg)](https://zenodo.org/badge/latestdoi/114820120)

Detailed doumentation is available at: http://hypertribe.readthedocs.io/en/latest/

For more details please see:

1. Xu, W., Rahman, R., Rosbash, M. Mechanistic Implications of Enhanced Editing by a HyperTRIBE RNA-binding protein. RNA 24, 173-182 (2018). doi:10.1261/rna.064691.117

2. McMahon, A.C.,  Rahman, R., Jin, H., Shen, J.L., Fieldsend, A., Luo, W., Rosbash, M., TRIBE: Hijacking an RNA-Editing Enzyme to Identify Cell-Specific Targets of RNA-Binding Proteins. Cell 165, 742-753 (2016). doi: 10.1016/j.cell.2016.03.007.
