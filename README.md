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
  Programmer.
- Reveal Controller Files (@ Reveal/). These include the Inserter,
  Analyser and Controller setup for the example design.

It is assumed the user is familiar with the basic operation of the Radiant
SW and the Radiant Programmer. The user should also have 

The user will also need the following:
- Certus-NX Versa Evaluation Board Rev B
- Radiant Software Suite v3.0

2.0 User Guide
==============

2.1 Overview
------------

The basic flow for using the design is as follows:

- Open the Design in Radiant 3.2 or newer
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

The operation of the register interface uses the following flow control:

// User Logic pseudo code
Step 1: Wait for write from JTAG side (Host Machine) to address 0x0 � detected by
        observing bit [0] of address 0x0 set to �1� in User Logic. Bits 31:1 must be
        latched once bit 0 is detected as �1�. 
Step 2: Wait for write from JTAG side (Host Machine) to clear address 0x0 � detected
        by observing bit [0] set to �0� in User Logic. Since bits 31:1 have been
        latched in step 1, this write from the host machine can completely clear
        register addr 0x0 to 0x00000000
Step 3: Execute command stored from address 0x0 (bits [31:1]) during Step 1.
Step 4: return to step 1

NOTE: It is recommended that all user applications utilise this flow control to avoid
race conditions between the user application and the Reveal Controller logic around
the Register Interface RAM.

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

```
> rva_close_controller
```

2.3.2 Interacting with the example design via Reveal Controller
---------------------------------------------------------------

Although not strictly part of the Reveal Controller usage, the following is a short
desciption of the behaviour in the DUT that is controllable from the Virtual Switches/LEDs
and the resulting changes that can be seen on the evaluation board.

2.3.2.1 Default behaviour before Reveal Controller is connected
---------------------------------------------------------------

The example design makes use of the 7-segment LED output (D36) the bank of 8 Green LEDs
adjacent to the DIP Switches and Push Buttons (D18, D19, D20, D21, D22, D23, D24, D25) and
Push Buttons 2. Push Button 3 acts as an asynchronous reset to the system - depressing
push button 3 will assert the reset.

When first programmed, LEDs D22, D23, D24, D25 will show a counter. LEDs D18, D19 will be
off, D20 will be illuminated and D21 will mirror D25. The 7-segment display will be off.

2.3.2.2 Reveal Controller behaviour
-----------------------------------

- LED Bank:

LEDs D22, D23, D24, D25 will show a counter based on the value of the Virtual Switches
(see below):

LEDs D18, D19, D20, D21 will show the output of the Virtual LEDs.

- 7-Segment Display:

The decimal point indicator shows when bit 0 of address 0x0 has been detected by the user
application (this indicates the upper bits of address 0x0 have been latched).
When bit 0 is cleared, the decimal point turns off and the 7-segment display will show the
character written to the upper 4-bits of the address 0x0. For example, to show the character
'A' on the 7-segment display the following two register writes should be performed:

Data 0xA001 should be written to address 0x90000000 (The decimal point will illuminate)
Data 0x0000 should be written to address 0x90000000 (the 7-segment will show 'A')

- Virtual LEDs:

The Virtual LEDs are assigned as follows:

Bit 3:0 : Will display the state of Virtual Switch Bits 3:0
Bit 4   : Will display the state of the Push Button 2 (PB2)

- Virtual Switches:

The Virtual Switches control the following behaviour:

// Counter Logic Pseudo Code
// if (Virtual Switch Bit 0 is set)
//   The counter is running (Virtual Switch Bit 1 defines the direction)
// else
//   if (Virtual Switch Bit 2 is set)
//     Clear the counter (set to all 0s)
//   else if (Virtual Switch Bit 3 is set)
//     Set the counter to all 1s

2.3.3 Running Reveal Controller via the TCL Console in the Radiant GUI
----------------------------------------------------------------------

The TCL interface to Reveal Analyzer / Controller provides all the functionality available
in the GUI. Any functionality implemented in the GUI is executed as a TCL command and
repeated at the TCL console in the Radiant GUI. As such, it is simple to find the command
for any GUI action by checking the TCL console after performing the action in the GUI.

Further to this, the TCL interface offers a richer set of commands than the Radiant GUI
interface. By using the TCL interface the full range of functionality available in the
Reveal Controller is exposed. 

2.3.3.1 The TCL Console
-----------------------

The TCL Interface to is available via the TCL Console tab in the Radiant GUI (at the
bottom of the GUI). At the TCL Console it is possible to get help on a particular command
using the following syntax:

```
> help <cmd>
```

Where <cmd> is any syntax matching a TCL command. Wildcards are supported. For example:

```
> help rva*controller
```

Will show a complete list of Reveal Analyzer commands. This is the resulting output:

```
> help rva*controller
-----------------------------------------------------------------------------------------------------
Commands                           | Description
-----------------------------------------------------------------------------------------------------
rva_close_controller               | Close Controller connection
rva_export_controller              | Export Controller file
rva_import_controller              | Import Controller file
rva_open_controller                | Open Controller connection
rva_read_controller                | Read Controller data
rva_run_controller                 | Run Controller command
rva_set_controller                 | Set Controller options
rva_target_controller              | Set Controller core target
rva_write_controller               | Write Controller data
-----------------------------------------------------------------------------------------------------

For help on an individual command, type 'help <command>'. For example: help prj_open
```

Similarly, help on a specific command can be printed by using the full command name in the
help command:

```
> help rva_run_controller
```

This is the resulting output:

```
> help rva_run_controller
rva_run_controller - Run command for Virtual LED, Virtual Switch, User Register and Hard IP
  Usage:
    rva_run_controller -read_led|-read_switch|-write_switch <data>|-dump_memfile <mem_file>|-load_memfile <mem_file>|-read_ip <ipname>|-write_ip <ipname>
    -read_led: Read data from Virtual LED
    -read_switch: Read data from Virtual Switch
    -write_switch: Write data to Virtual Switch
    -dump_memfile: Dump data from User Register to mem_file
    -load_memfile: Load data from mem_file to User Register
    -read_ip: Read data from Hard IP register
    -write_ip: Write data to Hard IP register
```

2.3.3.2 Interfacing with the Virtual Switches/LEDs and Register interface via TCL
---------------------------------------------------------------------------------

The basic process to run the Reveal Controller is as follows:

- Open the Reveal Controller via 'rva_open_controller'
- Execute the relevant Controller Commands'
- Close the Reveal Controller via 'rva_close_controller'

It is not strictly necessary to close the Reveal Controller between commands. But as
described in section 2.3.1.5 above, leaving the Reveal Controller connected can interfere
with other SW that is trying to use the JTAG interface.

An example set of commands using rva_run_controller is as follows

```
> rva_open controller
> rva_run_controller -write_switch 0x3
> rva_run_controller -read_switch
> rva_run_controller -read_led
> rva_close_controller
```

The user can refer to section 2.3.2 for a description of the functionality that can be
controller from the Reveal Controller.

2.3.3.3 USB Cable Setup via TCL
-------------------------------

If the 'rva_open_controller' command is unable to connect to the design, the most likelt
cause is that the USB Cable Setup is incorrect. The rva_set_controller command can be used
to correctly configure the USB Cable. This command is the alternative to the 'Detect
Cable' button in the GUI.

The cable type should be set to USb2 for the Certus-NX Versa Board. The port can vary
depending on the number of USB connections on the host system. 

```
> rva_set_controller -cable_type USB2
> rva_set_controller -cable_port 1
```

The current settings for the cable can be printed using the following command:

```
> rva_set_controller
```

2.3.4 Running Reveal Controller via the Standalone TCL Console
--------------------------------------------------------------

The Standalone TCL console is largely identical to the Radiant GUI TCL Console. All
commands that can be issued at the Radiant GUI TCL Console can also be issued via the
Radiant Standalone TCL Console. As such the user can refer to section 2.3.3 for guidance
on the TCL commands that can be used with the Standalone TCL Console.

It is necessary to set the cable connection (see Section 2.3.2) and open the Radiant
Project before opening the Radiant Controller. To do this:

- change working directory to the folder containing the Radiant Project.
- Open the Radiant project using the following command

```
% prj_open simple_rvl_ctrl_ex.rdf
```

- Set the cable connection - See section 2.3.3.3.
- Open the Reveal Controller

```
% rva_open_controller
```

From here all the commands described in section 2.3.3 can be run from the Standalone TCL
Console.
