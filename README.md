nibswap
=======

This is just a proof of concept for now.
Based on: http://stackoverflow.com/a/6227794/391112
Imagine a game that lets users customize its menus by editing nibs in interface builder.
Or a magazine-style app where issues/articles are built from Storyboards with complex View hierarchies and animations.
Lots of possibilities here, especially when you incorporate an interpreted language 
capable of interacting with the Objective-C runtime, say [Nu](http://programming.nu)

Instructions
===========

Move `example.bundle.zip` to an HTTP server (remote or local). 
Make sure to update the value of `kRemoteNibBaseURL` in `AppDelegate.m` to reflect the server's base URL.

Tell me if you come up with any crazy ideas.