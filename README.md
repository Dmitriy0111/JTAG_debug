# **JTAG_Debug**
    This is my sandbox for working with JTAG-debug module (RISC-V).

## Quickstart:
For loading project with git program:

    $ git clone https://github.com/Dmitriy0111/JTAG_debug.git 
    $ cd JTAG_debug 
    $ git checkout JTAG_debug

Or download project from GitHub site <a href="https://github.com/Dmitriy0111/JTAG_debug">JTAG_debug</a>

For working with project install:
*   make
*   Modelsim

## Simulation:
*   **make sim_dir** is used for creating simulation folder;
*   **make sim_clean** is used for cleaning simulation result;
*   **make sim_cmd** is used for starting simulation in command line (CMD) mode;
*   **make sim_gui** is used for starting simulation in graphical user interface (GUI) mode.

## Repository contents:
| Folder        | Contents                                          |
| :------------ | :------------------------------------------------ |
| doc           | RISC-V debug specification                        |
| rtl           | Design source files                               |
| run           | Scripts for simulation                            |
| tb            | Testbenches for design                            |
| other         | Readme file and Makefile                          |