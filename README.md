Epic Proton Selector

A lightweight Bash utility that lets you choose which Proton build Epic Games Launcher uses for individual games on Linux.

Use Valve Proton, Proton Experimental, GE-Proton, and other compatible community Proton builds with Epic Games Launcher.

No additional launcher, database, API, or background service required.

Why?

Epic Games Launcher uses its own compatibility runtime when launching Windows games on Linux.

Linux gamers may already have multiple Proton builds installed, but Epic Games Launcher doesn’t provide a built-in option to select those builds individually.

Epic Proton Selector provides a simple workaround by intercepting Epic’s Proton execution and forwarding the launch arguments to the selected Proton build.

Features

* Select Proton builds individually for each game.
* Supports Valve Proton, Proton Experimental, GE-Proton, and other compatible community builds.
* Lists installed Proton builds.
* Generates copy-ready launch options.
* Supports folder names containing spaces and underscores.
* Automatically falls back to Epic’s original Proton when no custom build is selected.
* Falls back to Epic’s original Proton if the requested build is unavailable.
* Preserves the original Epic Proton executable for restoration.
* Includes a separate uninstaller.
* No internet connection or external API required for Proton selection.
* No game database or per-game configuration files.

Requirements

* Linux.
* Epic Games Launcher AppImage.
* Steam installed.
* At least one compatible Proton build.
* Bash.
* Konsole for double-click terminal launching.
* kdialog for graphical error messages when Konsole is unavailable.

Installing Proton Builds

Epic Proton Selector does not download or manage Proton builds. You install and manage them separately.

Valve Proton

Install Proton versions through Steam.

Examples:

* Proton
* Proton Experimental

GE-Proton and Community Builds

You can use ProtonUp-Qt to download and install additional Proton builds, including GE-Proton.

ProtonUp-Qt provides a graphical interface for managing community compatibility tools.

Project: https://github.com/DavidoTek/ProtonUp-Qt

Proton Locations

Proton builds can be installed in different locations depending on how they were obtained.

Common locations include:

Steam’s common directory:

~/.local/share/Steam/steamapps/common/

Steam’s custom compatibility tools directory:

~/.local/share/Steam/compatibilitytools.d/

Additional Steam libraries may also have their own Proton installation directories.

Important: The current Epic Proton Selector scripts search:

~/.local/share/Steam/steamapps/common/

Proton builds installed by ProtonUp-Qt in compatibilitytools.d or other locations are not automatically detected by the current implementation.

To use those builds, they must be available in the location searched by the selector.

Installation

1. Download or clone this repository.
2. Make the scripts executable:

chmod +x install.sh uninstall.sh list-protons.sh

3. Run install.sh.
4. The installer locates Epic’s Proton runtime and replaces its executable with the selector while preserving the original as proton.epic.

The installer includes checks to avoid overwriting an existing installation.

Important: Back up your Epic runtime before installation if you have made other modifications to it.

Listing Installed Proton Builds

Run:

./list-protons.sh

The script searches the configured Steam Proton directory and lists installed builds that contain an executable named proton.

Example output:

--proton="GE-Proton11-11-x86_64"
--proton="Proton - Experimental"

Copy the desired option into the launch options of the corresponding game in Epic Games Launcher.

Selecting Proton for a Game

1. Open Epic Games Launcher.
2. Open the settings for the game.
3. Find its additional command-line arguments or launch options field.
4. Add the desired Proton option.

Example:

GE-Proton:

--proton="GE-Proton11-11-x86_64"

Proton Experimental:

--proton="Proton - Experimental"

5. Save the settings and launch the game.

The selector reads the folder name exactly as supplied.

Quotation marks are important when the folder name contains spaces. They allow the launch option to be passed as one argument.

Underscores are preserved and are not converted into spaces.

How It Works

Epic Proton Selector modifies the Proton executable inside Epic’s compatibility runtime.

The original executable is renamed:

proton → proton.epic

A custom Bash script takes its place.

When Epic launches a game, the script:

1. Reads the arguments passed by Epic.
2. Looks for an argument beginning with --proton=.
3. Extracts the requested Proton folder name.
4. Checks whether the corresponding Proton executable exists and is executable.
5. Launches the selected Proton build.
6. Forwards the remaining original arguments to it.

If no custom Proton build is specified, the script uses Epic’s original Proton executable.

If the requested Proton executable is unavailable or not executable, the script prints an error and falls back to Epic’s original Proton.

The original Epic launch arguments are preserved and forwarded to the selected runtime.

Uninstallation

Run:

./uninstall.sh

The uninstaller:

1. Searches for the proton.epic backup.
2. Identifies the corresponding runtime directory.
3. Temporarily moves the current Proton selector.
4. Restores Epic’s original Proton executable.
5. Removes the temporary selector file.

The uninstaller does not remove installed Proton builds or modify individual game launch options.

It also performs safety checks before restoring files.

Edge Cases and Limitations

1. Epic Games Launcher Updates

An Epic Games Launcher update may replace or recreate its compatibility runtime.

If that happens, the selector may stop working or be overwritten.

You may need to reinstall the selector after an update.

2. Proton Updates

When a Proton build is updated or removed, its folder may change or disappear.

If a selected Proton build is no longer available, the selector falls back to Epic’s original Proton.

3. Incorrect Proton Folder Names

The folder name must match the actual directory inside the configured Proton location.

Folder names are case-sensitive on typical Linux filesystems.

4. Proton Installed in Another Location

The current implementation searches only:

~/.local/share/Steam/steamapps/common/

Proton builds installed in additional Steam libraries or compatibilitytools.d are not automatically detected.

5. Proton Executable Permissions

The selected Proton build must contain an executable named proton.

If it is not executable, the selector falls back to Epic’s original Proton.

6. Folder Names Containing Spaces

Folder names containing spaces are supported.

Use quotation marks around the complete launch option:

--proton="Proton - Experimental"

Do not replace spaces with underscores.

7. Multiple Proton Selection Arguments

The selector processes arguments from left to right.

If multiple --proton= arguments are supplied, the last valid selection wins.

Invalid selections do not replace an earlier valid selection.

8. No Custom Proton Selection

If no --proton= argument is provided, Epic’s original Proton runtime is used.

9. Missing Original Backup

The uninstaller requires the original proton.epic backup.

If the backup is missing, the original runtime cannot be restored automatically.

Do not delete or rename proton.epic while the selector is installed.

10. Multiple Runtime Backups

The uninstaller expects exactly one matching proton.epic backup.

If multiple backups are found, it stops rather than guessing which runtime should be restored.

11. Modified Runtime Files

The uninstaller checks for the selector’s identification marker before restoring the original runtime.

If the marker is missing or modified, the uninstaller refuses to proceed.

This is a safety measure to avoid replacing an unrelated executable.

12. Game Compatibility

Selecting a different Proton build does not guarantee that a game will work.

Compatibility depends on the game, Proton version, graphics drivers, dependencies, anti-cheat systems, and other factors.

Some games may work better with Epic’s original Proton.

13. Launcher Argument Handling

The selector depends on Epic passing the custom --proton= argument as a single argument.

Quoted launch options containing spaces have been tested with the supported setup.

Other launchers or different argument-processing behavior may require additional testing.

14. Runtime Modifications

This utility modifies Epic’s bundled compatibility runtime.

It is not an official Epic Games or Valve feature.

Use it at your own risk. Keep the original backup intact.

Troubleshooting

The game still launches using Epic’s original Proton.

* Check that the selector is installed in the correct runtime directory.
* Verify the launch option spelling.
* Check that the requested Proton folder exists.
* Verify that its proton executable has executable permissions.

A Proton build does not appear in the list.

* Check that it is installed in the configured Proton directory.
* Check that its folder contains an executable named proton.
* Check whether it was installed in compatibilitytools.d or another unsupported location.

The uninstaller reports an unrecognized Proton file.

The selector identification marker may be missing or modified.

Check the installed runtime before manually restoring files.

The uninstaller reports multiple backups.

More than one proton.epic file was found. Inspect the runtime directories before proceeding.

The game stops launching after an Epic update.

Check whether the update replaced the modified runtime. If necessary, reinstall the selector.

Project Scope

Epic Proton Selector intentionally focuses on one task: choosing a compatible Proton build for an Epic Games Launcher game.

It does not aim to replace Epic Games Launcher, Steam, ProtonUp-Qt, Heroic Games Launcher, or other compatibility management tools.

There is no online service, account integration, game database, or automatic game detection.

The goal is to keep the utility small, understandable, and easy to maintain.

License

MIT License.

See LICENSE for details.

Disclaimer

Epic Proton Selector is an independent community utility.

It is not affiliated with, endorsed by, or supported by Epic Games or Valve Corporation.

Epic Games, Epic Games Store, Steam, Proton, and Proton Experimental are trademarks or products of their respective owners. GE-Proton is a community-maintained Proton distribution.
