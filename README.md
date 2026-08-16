# omakasui-devtools

Development tooling for people working across the Omakasui ecosystem.
Everything here is aimed at developers of those projects, not for the end user.

Installs as either `omakub-devtools` or `omadeb-devtools` (same content,
mutually exclusive packages — pick whichever matches your environment). Both
commands behave identically.

## Commands

```
<cmd> theme generate background <themes dir> [output file]   Generate background.png wallpapers
<cmd> theme generate bootloader <themes dir> [output file]   Generate GRUB bootloader backgrounds
<cmd> theme generate logo <themes dir> <logo.png>             Generate themed unlock.png logos
<cmd> theme generate preview <themes dir>                     Generate preview-unlock.png previews
<cmd> theme format previews <themes dir>                      Resize/optimize existing preview images
```

Run `<cmd> commands --all` for the full list, or `<cmd> <command> --help` for
details, where `<cmd>` is `omakub-devtools` or `omadeb-devtools`.
