Simple Reveal Controller Example
================================

1.0 Design Overview
===================

1.1 The Design Package
----------------------

This package includes:

- Simple RTL design (@ src/) so the Reveal Controller has some basic
  functionality to monitor/interact with.
- Basic Radiant project files (Project, Constraints, Strategy) - these
  are provided as examples and should not be considered complete or final.
- Programmer files (@ Programmer/). An XCF programming file is provided
  for the Certus-NX Versa Board. This file can be used with Reveal
  Programmer v3.0 or newer.
- Reveal Controller Files (@ Reveal/). These include the Inserter,
  Analyser and Controller setup for the example design.

It is assumed the user is familiar with the basic operation of the Radiant
SW and the Radiant Programmer.

2.0 User Guide
==============

2.1 Overview
------------

The basic flow for using the design is as follows:

- Open the Design in Radiant 3.0 or newer
- Build the design to generate a programming bitstream
- Program the bitstream into the Certus-NX Versa Board.
- Open the Reveal Controller (via GUI or TCL prompt) to interfact with
  the design.

The current implementation supports the following functionality for interacting
with the design:

- Virtual Switches   : To allow individual registers to be written from the PC
- Virtual LEDs       : To allow individual registers to be read from the PC
- Register Interface : To allow register values to be read/written into a
                       Dual-Port RAM in the device.

2.2 Generating the programming bitstream and programming the evaluation board
-----------------------------------------------------------------------------

Once the design has been opened in Radiant, a new bitstream can be generated by
running Export Files. Once the Export files process is complete the bitstream will
be generated at:

impl_1/simple_rvl_ctrl_ex_impl_1.bit

The bitstream can be programmed into the Certus-NX device by:
- Connecting a Certus-NX Versa Evaluation Board via the supplied MicroUSB cable.
  Power the evaluation board by connecting the supplied wall adapter to J35.
- Opening the Radiant Programmer. This is most conveniently achieved by opening
  the XCF file provided under the Programming Files section of the Radiant GUI.
- Once the supplied XCF file is opened in the Radiant Programmer (this happens
  automatically if the Radiant Programmer is launched by opening the XCF file in
  the Radiant GUI) the Radiant Programmer will already be configured to program
  the Certus-NX device.
- Complete cable configuration by clicking on the 'Detect Cable' button in the
  upper right corner of the Radiant Programmer. Ensure the cable was correctly
  detected. The following message should be printed to the Radiant Programmer
  Output console:

  INFO - Board with FTDI USB Host Chip detected.

- Program the Certus-NX device via Run -> Program Device. This will program the
  bitstream into the Certus-NX device. Success will be indicated by the following
  messages printed to the Output Console:

  INFO - Device1 LFD2NX-40: Fast Configuration

  INFO - Operation Done. No errors.

  INFO - Elapsed time: 00 min : 10 sec

  INFO - Operation: successful.

Once correctly programmed, the evaluation board should show a 4-bit counter on
LEDs D22, D23, D24, D25 (located on the top edge of the board adjacent to the
DIP switches and push buttons).

2.3 Running the Reveal Controller
---------------------------------

Once the Certus-NX device on the evaluation board has been programmed, the Reveal
Controller can be connected to the board. There are several ways to do this:
- via the Radiant GUI
- via the TCL Console tab in the Radiant GUI
- via the Standalone TCL Console tool supplied with the Radiant SW.

NOTE: This design implements Virtual LEDs, Switches and Register Interface. 

2.3.1 Running Reveal Controller via Radiant GUI
-----------------------------------------------

The Reveal Controller is available via Tools -> Reveal Analyser / Controller in the
Radiant GUI. However, for this example design a pre-configured Analyser/Controller
file is supplied in the project (under Debug Files).

To create a new Reveal Analyser file:
- Complete step 2.2 to generate the bitstream and program into the Certus-NX Versa
  Evaluation Board 
- Open the Reveal Analyzer Startup Wizard via Tools -> Reveal Analyzer / Controller
- Select 'Create a new file' and assign the Analyzer a name under
- Click on 'Detect' button to setup the cable connection, after a short pause the
  'USB Port' field should be updated with an entry starting 'FTUSB-' - the location
  and ID of the USB connection will depend on the number of USB connections on the
  Host PC.
- Click on the Scan button to detect the Reveal Core in the Certus-NX device. 
  NOTE: If this step fails check the image programmed into the Certus-NX device
  contains the expected Reveal Inserter Core. Further troubleshooting is provided in
  the Reveal Troubleshooting Guide. This guide is available under 'User Guides' on
  the Radiant Start Page.
- Check the path to the RVL Source file is correct (this should be automatically
  picked up from the active Reveal Inserter file in the Radiant project).
- Click on OK to complete the setup and generate the Reveal Analyzer file.

Open the Reveal Analyzer file supplied with the example project:
'Reveal/simple_rvl_ctrl_a.rva' by either double clicking or right click -> Open.
This will open the Reveal Analyzer / Controller tab.

By default the tab shows the Analyser view. Switch to the Controller view via the
drop down located at the top of the tab towards the right (labelled
'top_rvl_ctrl_ex_LA0'). From the drop down select 'top_Controller' to show the
Controller view.

The initial view shows the Virtual LED Switch tab. Different tabs can be selected
via the tabs shown at the bottom of the Analyzer / Controller tab. This example
design includes Virtual LEDs, Switches and a User Register interface. 

2.3.1.2 Monitoring Virtual LED values via the Radiant GUI
---------------------------------------------------------

The state of the Virtual LEDs reflects the state of the signals attached to the
Virtual LEDs in the user design. A logic '1' on the associated signal in the user design will be reflected by a green illuminated 'LED' in the GUI.

Click on the 'Polling Once' button to snapshot the current state of the Virtual LEDs.
Click on the 'Start Polling' button to continuously poll the state of the Virtual
LEDs. The interval between polls canbe controlled by the 'Polling Speed' slider.

2.3.1.3 Controlling Virtual Switches via the Radiant GUI
--------------------------------------------------------

Like the Virtual LEDs, Virtual Switches can either be single shot or continuous. To
make a single update to the Virtual Switch values set the switch positions and click
the Apply button. To continuously set the Virtual Switches check the 'Direct Mode'
box - the values set in the GUI willbe continuously written to the Virtual Switches
in the user design.

Set the switch in the lower position to set the Virtual Switch to the logic '0' state.
Set the switch in the upper position to set the Virtual Switch to the logic '1' state.

2.3.1.4 User Register Interface via the Radiant GUI
---------------------------------------------------

Open the Register Interface view by clicking on the tab labelled 'User Register'. From
this tab it is possible to write/read values to/from any valid address. NOTE: the valid
address range is shown at the top of the tab. The range is 0x90000000 to 0x9000FFFF).

In this example design, register values between 0x90000000 and 0x9000000F are
automatically updated by the RTL.

It is also possible to write/read a range of memory values using the memory dump feature.
Specify the memory range and file to load (if writing to the registers) or 'dump' (if
reading the registers).

2.3.1.5 Closing the Reveal Controller via the Radiant GUI
---------------------------------------------------------

If the Radiant Controller has an active connection to the evaluation board (for example
if LED Polling is enabled or Virtual Switch 'Direct Mode' is enabled) then it is
necessary to close the connection to release the USB connection between PC and the
evaluation board. Failure to do this can result in other SW being unable to connect to
the board. Typically this would result in the Radiant Programmer

The most reliable way to close the Radiant Controller is via the TCL console (either in
the Radiant GUI or Standalone Radiant TCL Console). At the TCL prompt run the
'rva_close_controller' command:

> rva_close_controller

2.3.2 Running Reveal Controller via the TCL Console in the Radiant GUI
----------------------------------------------------------------------

The TCL interface to Reveal Analyzer / Controller provides all the functionality available
in the GUI. Any functionality implemented in the GUI is executed as a TCL command and
repeated at the TCL console in the Radiant GUI. As such, it is simple to find the command
for any GUI action by checking the TCL console after performing the action in the GUI.

Further to this, the TCL interface offers a richer set of commands than the Radiant GUI
interface. By using the TCL interface the full range of functionality available in the
Reveal Controller is exposed. 

The TCL Interface to is available via the TCL Console tab in the Radiant GUI (at the
bottom of the GUI). At the TCL Console it is possible to get help on a particular command
using the following syntax:

> help <cmd>

Where <cmd> is any syntax matching a TCL command. Wildcards are supported. For example:

> help rva*

Will show a complete 
