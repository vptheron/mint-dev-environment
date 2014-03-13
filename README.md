## Overview

This self-contained [Chef](http://www.getchef.com/chef/) repository can be used to provision a vanilla [Mint 16 "Petra"](http://www.linuxmint.com/) system and set up a developer environment tailored to my personal needs and workflow.

The main cookbook has been developed and tested **only** on **Linux Mint 16 "Petra"**. It will probably not work on a different OS/version.

## Getting ready to run the installer

It is assumed that you have `git-core` installed and you have cloned this repository.

```
sudo apt-get install -y git-core
git clone https://github.com/vptheron/mint-dev-environment ~/mint-dev-environment
cd ~/mint-dev-environment
```

## Configuring the environment

The configuration of the environment is located in `mint.json`. 

* `run_list` - lists all the recipes that will be executed, set to `mint-dev-environment` which should be all you need.
* `mint-dev-environment.username` - the username of the account to set up (note that part of this cookbook will perform system-wide changes).
* `mint-dev-environment.full_name` - the full name of the user.
* `mint-dev-environment.email_address` - the email address of the user.
* `mint-dev-environment.desktop` - the desktop environment to configure. Valid values are `cinnamon` and `mate`, other values are ignored (so to skip the desktop environment configuration just set this attribute to `none` for example).

## Running the installer

From the cloned repo, run `install.sh` 

```
chmod a+x install.sh
sudo  ./install.sh
```

## What will be done

### System-wide modifications

* **Chef** is installed via **curl** (which is installed as well)
* **Chromium** replaces **Firefox**
* **Adobe Flash Plugin** replaces **Mint Flash Plugin**
* Installed languages/build tools/etc: **OpenJDK 7**, **sbt-extras**, **Leiningen**, **Haskell Platform**
* Other applications/packages installed: **vim**, **Skype**, **Calibre**, **Clementine**, **Brasero**, **meld**
* Other applications/packages removed: **Tomboy**, **Gthumb**, **Gimp**, **Pidgin**, **Thunderbird**, **xchat**, **Banshee**, **Totem**

### For the specified user

* Directories `~/Public and` `~/Templates` are removed
* Directory `~/Devel/tools` is created
* **IntelliJ IDEA** is installed in `~/Devel/tools/`
* **Git** is configured to use the full name and email address specified in `mint.json`
* **rbenv** and **ruby-1.9.3** are installed, as well as the **bundler** gem
* The desktop environment is configured (see below for details)

### Desktop environments

Two environments are currently supported: **Cinnamon** and **MATE**. Note that for **MATE**, the package **dconf-tools** will be install.

| Change/Update                                            | Cinnamon | MATE |
|:---------------------------------------------------------|:--------:|:----:|     
| **Computer** and **Home** icons are removed from desktop |    Yes   |  Yes |  
| **Trash** icon is added to desktop                       |    Yes   |  Yes |     
| Background image is updated                              |    Yes   |  Yes |    
| Clock format is set to 12-hour                           |  No (1)  |  Yes |
| Main menu replaces Mint menu in the panel                |    N/A   |  Yes |
| **Files** launcher is added to the panel                 |    Yes   |  No  |
| **Terminal** launcher is added to the panel              |    Yes   | Yes  |
| **Chromium** launcher is added to the panel              |    Yes   | Yes  |
| Some applets are removed from the panel                  |    Yes   | No   |
| Scrolling is enabled for **Window List** applet          |    Yes   | N/A  |
| **Terminal** key bindings are updated                    |    No    | Yes  |    
| Remove favorite apps shortcuts from main menu            |    Yes   | N/A  |
| Configure power manager to favor hibernation             |   Yes    | No   |

(1) The recipe does not automatically update the calendar applet to change the time format, however, it contains a json settings file that can be imported from the applet configuration window. The file is `cookbooks/mint-dev-environment/files/default/date_applet.json`.

## Not added yet (hopefully soon!)

* Use an attribute to specify a list of git repositories to clone for given user
* Deactivate useless Startup Applications
* Edit the main menu to remove useless entries and add IDEA Intellij under "Programming"
