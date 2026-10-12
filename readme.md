# ISAM 102 Workshop

This repository contains files relevant to the ISAM 102 Workshop, offered as part of the [ISAM (International Symposium on Academic Makerspaces)](https://isam2026.hemi-makers.org/) conference hosted at Rice University in Houston, TX on October 11, 2026.

## Key links

* [The workshop slide deck](https://docs.google.com/presentation/d/1ssW1kLEdIV6doIdHSlkZcHQL9aKUUs60g7Cv7FatsbY/edit?usp=sharing) gives a good overview of the project
* [Bill of materials](https://docs.google.com/spreadsheets/d/1SMaYd1W7RdJwxCUgwH0dufXo5XOK3xKtL_PFmABzuK0/edit?usp=sharing) including costs and sources (also linked below)
* Most design files are contained in this repo, organized by the design software used. Our Fusion designs are viewable (and downloadable) below:
  + [Chassis base](https://a360.co/3UgWDdf)
  + [3d-printed 36 tooth gear](https://a360.co/4jhnJLu)
  + [Snap-fit rings](https://a360.co/4AZ4c8O)
  + [Scotty dog](https://a360.co/4AZ4c8O)
  + [Tail wagger](https://a360.co/4dzIVbR)
  + [Gear arrangement sketch](https://a360.co/4dyHuKM)

## Workshop printouts

document | document source (copy and modify) | PDF
--- | --- | ---
Bill of Materials (BOM) handout | [Google Sheets BOM](https://docs.google.com/spreadsheets/d/1SMaYd1W7RdJwxCUgwH0dufXo5XOK3xKtL_PFmABzuK0/edit?usp=sharing); [draw.ioRef.org bolt lengths and simplified schematic](https://drive.google.com/file/d/1bY67-kRYnys0FUMiLNIe3cIf9ZiAv4Ug/view?usp=sharing) | [PDF](<workshop printouts/ISAM 102 BOM, bolt length chart, reference schematic.pdf>)
More detailed schematic | [draw.ioRef.org source](https://drive.google.com/file/d/195w9GBgT-5P33YUQ5w68HSQIwB7dRBu5/view?usp=sharing) | [PDF](<workshop printouts/big schematic.pdf>)
Blown-up breadboard photo | | [PDF](<workshop printouts/blown-up circuit photo.pdf>)
Order of construction (used by organizers) | [Google Docs source](https://docs.google.com/document/d/1IrMTVL7Qs2d7-0CwFLS_1lchCKMhTqDqpBA163-08qU/edit?usp=sharing) | [PDF](<workshop printouts/Order of construction.pdf>)

## Free and open-source software mentioned in the workshop

### CAD and mechanical simulation

* [OpenSCAD](https://openscad.org/), "The programmer's solid 3D CAD modeller," compiles your software-style source code into geometry. It allows for highly parameterized drawings, and can be called from the command line.
* [LibreCAD](https://librecad.org/) is a DXF-native drawing application designed for producing engineering drawings in two dimensions. 
* [SolveSpace](https://solvespace.com/) has an interface that looks like it's from about 1989, but but that's just part of its charm; it can draw in two and three dimensions including using parameters if you wish, and also can simulate kinematic linkages as we demonstrated.
* [Inkscape]() is a vector-drawing application suitable for opening DXFs and SVGs from CAD software, to add final touches before sending to a lasercutter (or drawing from scratch). The "Hershey text" extension is great for lasercutting.
* [Boxes.py](https://boxes.hackerspace-bamberg.de/?language=en) is a very useful compendium of parametric lasercuttable objects.

### Schematic capture and circuit simulation

* [KiCAD](https://kicad.org/) is a very fully-featured circuit and PCB design suite, including simulation. We used it to create our CNC milled circuit and industrially-fabbed PCB.
* [Falstad's circuit simulator]() written by Paul Falstad, actually shows current flowing through the wires (excellent for understanding what's going on in an active circuit), and runs entirely in the browser. It also has a fabulous range of sample circuits under the "circuits" menu.
* [The ioRef schematic and system drawing tool](https://draw.ioref.org) is a customized version of [draw.io](https://www.drawio.com/), with block-level and schematic-level electronic components meant to make it easy for beginners to draw clear, legible circuits.

### Microcontroller wiring and programming

* [Breadboard secrets](https://cmuiii.ai/examples/wiring) is a simple page to help students understand the relationship between the breadboard and the circuit represented on it. It was written with AI assistance by faculty from Carnegie Mellon's Integrated Innovation Institute.
* [Arduino code](https://cmuiii.ai/examples/code) is another simple demo visualizing the actual electronics results of running each line of an Arduino sketch, also from CMU's III.

## Workshop leaders

* [Robert Zacharias](https://www.andrew.cmu.edu/user/rzachari), Associate Teaching Professor, IDeATe (Integrative Design, Arts, and Technology) and Entertainment Technology Center, Carnegie Mellon University
* [Bill Nace](https://www.ece.cmu.edu/directory/bios/nace-bill.html), Teaching Professor, Electrical and Computer Engineering, Carnegie Mellon University