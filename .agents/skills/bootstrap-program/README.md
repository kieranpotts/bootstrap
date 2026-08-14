# Bootstrap program

The procedure for adding a tool to the bootstrap provisioning run, changing
how an existing tool is installed, or removing one.

The skill walks an agent through the whole change, not just writing the shell
script.

## Interactivity

The agent is instructed to resolve the target program and install profile from
the context and environment, but to confirm with the user if there is any 
doubt about these parameters.

For the install profile (`cli`, `tui`, or `gui`), the agent attempts to 
classify the program from its man page or upstream documentation.

## How to invoke

> Add ripgrep to the bootstrap.

> Install lazydocker on new machines.

> Move Obsidian to the gui profile.

> Drop Insomnia from the bootstrap.

> Install ripgrep via apt.

> Check this apt command.

> Review the apt calls in this install step.

> Why does this package step prompt on a fresh machine?

## Recommended models

A mid-tier model is a good fit. Most of the work is mechanical, but classifying 
a program into the right profile and choosing an install mechanism call for 
judgment.
