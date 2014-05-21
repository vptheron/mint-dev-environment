## Overview

This self-contained [Chef](http://www.getchef.com/chef/) repository can be used to provision a vanilla [Mint 17 "Qiana" - Cinnamon](http://www.linuxmint.com/) system and set up a developer environment tailored to my personal needs and workflow.

The main cookbook has been developed and tested **only** on **Linux Mint 17 "Qiana" - Cinnamon**. It will probably not work on a different OS/version. (Note: see tagged versions of this repository for previous versions of Linux Mint)

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
* Other applications/packages installed: **vim**, **tree**, **Skype**, **Calibre**, **Clementine**, **Brasero**, **meld**
* Other applications/packages removed: **Tomboy**, **Gthumb**, **Gimp**, **hexchat**, **Pidgin**, **Thunderbird**, **xchat**, **Banshee**, **Totem**

### For the specified user

* Directories `~/Public and` `~/Templates` are removed
* Directory `~/Devel/tools` is created
* **IntelliJ IDEA** is installed in `~/Devel/tools/`
* **Git** is configured to use the full name and email address specified in `mint.json`
* **rbenv** and **ruby-1.9.3** are installed, as well as the **bundler** gem
* The desktop environment is configured (see below for details)

### Desktop environment

**Cinnamon** is now the *only* supported desktop environment. The following changes are applied by the cookbook:

* Desktop effects are disabled
* Desktop icons: **Computer** and **Home** are removed, and **Trash** is added
* Background image is updated
* Clock format is set to 12-hour and display the date in addition to the time (1)
* **Chromium** launcher is added to the panel (in replacement of **Firefox**)
* Some applets are removed from the panel: *Show desktop*, *User applet*, *Keyboard* and *Window Quick List*
* Scrolling is enabled for **Window List** applet
* Remove favorite apps shortcuts from main menu
* Configure power manager to favor hibernation

(1) The default date format displays the full name of the day. A json settings file is provided to update the date format and use the short version, it can be imported from the applet configuration window. The file is `cookbooks/mint-dev-environment/files/default/date_applet.json`.

## Not added yet (hopefully soon!)

* Use an attribute to specify a list of git repositories to clone for given user
* Deactivate useless Startup Applications
* Edit the main menu to remove useless entries and add IDEA Intellij under "Programming"
