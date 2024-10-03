# Mike's macOS Disk Cleanup Script

=====================================

## Overview

## ![important] ***THIS MIGHT REMOVE STUFF YOU ACTUALLY WANT TO KEEP***

This script will clean up your Mac's disk space. Aggressively.
Currently it searches for (and cleans) the following items:

- MacOS Trash
- MacOS (User) Library Caches
- meteor package cache (shared between projects)
- meteor projects in your development base directory
- node_modules folders in your development base directory
- npm cache
- yarn cache
- bun cache
- Xcode DerivedData
- Xcode DeviceLogs
- iOS device support files
- Xcode caches
- gradle caches
- android build folders
- ruby gems
- docker containers, images, volumes, etc
- Android SDK packages
- Android AVDs
- Homebrew caches

## How to Use the Script

1. `npx mikes-macos-developer-disk-cleanup`
2. Panic because all your files are now gone and are never coming back.

## Important Notes

- This script is designed for use on macOS systems only.
- Be cautious when running the script, as it permanently deletes files and data.
- Make sure to review the script's actions before confirming the cleanup.

## Version History

- v1.0: Initial release


<!-- 
 ======= Links, styles, images etc go below this point ========
--->

<!-- LINKS -->


<!-- IMAGES -->

[important]:./assets/important.svg "important"

<!-- STYLES -->
<!--
Note: GitHub will ignore the <style> element and will render its contents,
 so we embed it in a collapsed <details> accordion, which itself gets hidden in other
 markdown renderers that respect the <style> element (i.e. not github).
-->

<hr />
<details id="cssblock">
<summary>
<!-- GH logo -->
<img
  src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/github/github-original-wordmark.svg"
  width="30" alt="github logo"
/>
</summary>

> GitHub renders the following as gibberish, while other viewers will apply the CSS styles.

<style type="text/css">
  img[title~="logo"] {
   width:128px;
   max-width: 25%;
   margin: 1em;
   vertical-align: middle;
  }
  img[title="important"] {
    width: 100px;
    margin: 0 1em;
    vertical-align: middle;
  }
</style>
</details>