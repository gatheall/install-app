# install-app

A handy utility for installing and upgrading software, whether compiling from source or using a package manager.

## Introduction

This script removes much of the drudgery associated with installing and upgrading software.  It supports retrieving distribution files as well as configuring / compiling / installing arbitrary software applications.  Unlike package managers such as Red Hat's **rpm**, Debian's **dpkg**, Sun's **pkgadd**, etc., **install-app** works typically with a application's source, giving you complete flexibility in terms of configuration and installation.  Indeed, the flexibility is such that you can even use it with your OS' package manager.  [Another difference _vis-a-vis_ **install-app** and package managers is that **install-app** does not itself support dependencies among applications or application removals.]

**install-app** requires Perl 5 along with the following Perl modules:

* `Carp`
* `File::Find`
* `Getopt::Long`
* `LWP::Debug`
* `LWP::UserAgent`
* `Text::Wrap`
* `XML::Twig`

If your system does not have these modules installed already, visit [CPAN](http://search.cpan.org/) for help.  Note that `LWP::Debug`, `LWP::UserAgent`, and `XML::Twig` are not included with the default Perl distribution so you may need to install them yourself. Also note that `XML::Twig` itself requires the [Expat XML parser library](http://expat.sourceforge.net/).


## Application Info Files

For each application you wish to support with this script, you must have a special file -- an _application info file_ -- containing information about the application: where the distribution file is located, how to verify its integrity, how to compile the application, etc.  An application info file resides in the directory specified in the script by `$apps_dir`.

An application info file is an XML document.  Currently, the document must only be _well-formed_, although at some point I hope to create a document type definition (DTD) with which it can be validated.  In the meantime, here is a table listing the elements that can appear in an application info file along with the meaning of each:

| XPath | Meaning |
| ----- | ------- |
| `name` | Alternate name of the application.  This can be useful encoded in other elements such as `distfile` when you want to give the application info file a friendlier          name; eg, `spamassassin` instead of `Mail::SpamAssassin`. |
| `url` | Homepage for the application.  [NB: unused by **install-app**. |
| `install/basedir` | Base directory where distribution file is saved and files are extracted.  **install-app** will create it if it doesn't already exist. |
| `install/workdir` | Work directory, created either implicitly when extracting files or explicitly as part of a `postextract` action.  **install-app** will change into this after extracting files and perform each step there. If a relative path, it will be relative to the base directory. |
| `install/distfile` | Distribution filename for a specific version. |
| `install/durl` | URL from which the distribution file can be obtained. **install-app** supports file retrievals via HTTP and FTP using `LWP`. |
| `install/verify` | Method used to verify contents of the distribution file. Possible methods are `md5` (MD5 checksum) and `sig` (GnuPG / PGP signature). If omitted, **install-app** will not attempt to verify the integrity of the distribution file. |
| `install/vurl` | URL used to obtain the MD5 checksum or GnuPG / PGP signature for the distribution file. |
| `install/preextract` | Command(s) run before extracting contents of the distribution file.  These are passed to the shell for execution. **Note:** if they exit with a non-zero return code, **install-app** will regard that as a failure and abort. |
| `install/postextract` | Command(s) run after extracting contents of the distribution file but before changing ownership of the working directory or performing any steps.  These are passed to the shell for execution. **Note:** if they exit with a non-zero return code, **install-app** will regard that as a failure and abort. |
| `install/step/label` | Descriptive label of the action to be performed for a given step. |
| `install/step/action` | Command(s) to be performed for a given step. These are passed to the shell for execution. Generally, there will be multiple steps for an application; they will be performed in the order they appear in the application info file.  **Note:** if an action exits with a non-zero return code, **install-app** will regard it as a failure and abort. |
| `install/component` | Can hold any / all of the same elements as `install`, except for `component`.  Intended for applications that consist of multiple distribution files. |

Within an element, text can be encoded using one or more special strings:

| Encoding | Replaced By |
| -------- | ----------- |
| `%a` | Name of the application as specified on the commandline. |
| `%b` | The text of the `basedir` element. |
| `%f` | The text of the `distfile` element. |
| `%n` | The text of the `name` element. |
| `%v` | The version number specified on the commandline. |
| `%w` | The text of the `workdir` element. |


## Installation

* Retrieve [the script](install-app) and save it locally.
* Verify ownership and permissions on the script and configuration file - they should be owned by root.
* Create an application info file for each application you wish to have **install-app** support.  Some examples are: [iptables.xml](iptables.xml) and [perl.xml](perl.xml. Note: these are intended as guides to help you write your own application info files. While you may choose to use them as-is to install these particular applications, you may prefer to use different steps or even not install the applications at all.
* Verify ownership and permissions on the script as well as application info files.
* Edit the script and set `$ENV{PATH}`, `$apps_dir`, and `$proxy` according to your environment.  Also, you may wish to adjust the location of the perl interpreter in the first line as well as other variable initializations to suit your tastes.
* Optionally, retrieve the stylesheet [app.xsl](app.xsl) for use in displaying application info files.


## Use

You specify applications to install / upgrade on the commandline as one or more name / version number pairs.  For each application, **install-app** will read the corresponding application info file and then use the information it obtains to retrieve the appropriate distribution file, verify its integrity, extract it, and configure / compile / install the application.  At each step, you will be prompted to continue to the next step or skip it.

There are several commandline arguments you can use; some override variables defined in the script itself:

| Option | Meaning |
| ------ | ------- |
| `-a, --list-apps` | List the applications supported on this system and exit. |
| `-b, --batch` | Don't ask questions. NB: you may still be prompted by the programs you are actually running. |
| `-d, --debug` | Display debugging messages while running.  NB: installs still occur. |
| `-l, --list-steps` | List the steps to make and install the application but don't actually do them.

Examples:

| Invocation | Meaning |
| ---------- | ------- |
| `install-app openssl 0.9.7a` | retrieves / builds / installs OpenSSL 0.9.7a. |
| `install-app -b openssl 0.9.7a` | same as above but do it in batch. |
| `install-app -l openssl 0.9.7a` | lists steps involved in building / installing OpenSSL 0.9.7a. |
| `install-app --list-apps` | lists supported applications. |


## Known Bugs and Caveats

Currently, I am not aware of any bugs in this script.

The application info files contain arbitrary commands that are run as root.  Be careful about what you put in them, and be careful about their ownership / permissions.

Make sure you set `$ENV{'FTP_PASSIVE'}` in the script if your firewall requires passive mode for FTP file transfers.

You may sometimes be prompted for information while running **install-app**, even when using its batch option (eg, `-b`).  By carefully choosing the steps followed in an application info file, you can minimize or even eliminate the need for user interaction.  For instance, don't have a step that invokes `vi` to edit a makefile; instead, use `sed` to edit a it in place.  Also, note that **install-app** sets the environment variable `INSTALL_APP_MODE` to `batch` if running in batch mode so you have a step that, say, allows you to page through a changelog only if running interactively.

Currently, **install-app** requires that distribution files be tar files compressed using `compress`, `gzip`, or `bzip`.

If you encounter a problem using **install-app**, I encourage you to enable debug mode (eg, add `-d` to your commandline) and examine the output it produces before contacting me.  Often, this will enable you to resolve the problem yourself.


## Copyright and License

Copyright (c) 2003-2016, George A.  Theall.
All rights reserved.

This script is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
