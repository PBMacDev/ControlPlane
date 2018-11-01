ControlPlaneX
============

What is ControlPlaneX
--------------------

ControlPlaneX, a fork of MarcoPolo, brings context and location sensitive awareness to OS X.  With ControlPlaneX you can intelligently reconfigure your Mac or perform any number of actions based on input from a wide variety of evidence sources including but not limited to available WiFi networks, current location, connected monitors, connected and nearby bluetooth devices, currently running apps and other configurable sources.  You will find a full feature list at <http://www.ControlPlaneXapp.com/feature-list>.

How ControlPlaneX Works
----------------------

Using fuzzy logic, ControlPlaneX decides where you are and/or what you are doing (called a Context) using rules that you configure to then carry out any number of configured actions.

An example of how to use ControlPlaneX may include disabling the screensaver password while at work but enabling it when away from work.  Another example would be to set your Adium status.

How to Get ControlPlaneX
-----------------------

You can download the most recent version of ControlPlaneX from [the ControlPlaneX website](http://www.ControlPlaneXapp.com). Once installed you will be automatically notified of any new updates that become available.

Building ControlPlaneX from Source
---------------------------------

ControlPlaneX is free, open source software hosted at <https://github.com/dustinrue/ControlPlaneX>.  Before you can build ControlPlaneX you will need the following:

1. Xcode 10.0+.
2. A git client if you don't wish to use Xcode itself, the command line tools for Xcode include the Git command line client.
3. OS X version 10.14.

If you wish to build ControlPlaneX yourself you can do so by cloning the ControlPlaneX code to your computer using Xcode or your preferred git client.  Once cloned, open the project file in Xcode and edit the Action.h file to enable or disable the building of the iChat action.
