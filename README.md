# Franklin Stuff

The Franklin ACE 1000 line was a clone of the Apple II+. Famously, the ROMs were direct copies of Apple's ROMs, and this went to the courts. After losing, and because technology advanced, Franklin released more advanced machines:

* Franklin ACE 2X00 (where X is the number of built-in disk drives) - an Apple IIe clone
* Franklin ACE 500 - an Apple IIc clone

Both of these had custom ROMs, both to avoid infringing on Apple's IP and to handle built-in feature such as parallel ports and disk controllers.

This repo is about investigating these ROMs to understand how they work, how the machines differ from the Apple machines they are based on, how the ROMs evolved over time, and bugs present in the ROMs.

## Versions

At least two versions of the 2X00 ROMs are known to exist:

* v5.X - identifies like an original IIe with $FBC0=$EA; has significant compatibility issues
* v6.0 - identifies like an Enhanced IIe with $FBC0=$E0

Only one version of the 500 ROM is known to exist:

* v1.0 - identifies like a IIc with $FBC0=$00

## Bugs

There are at least three significant compatibility bugs in the 6.0 Franklin ROMs:

* With 80-column/enhanced firmware active, horizontal cursor position must use `OURCH` ($57B) not `CH` ($24). This affects only the 2X00. This is documented by Apple, but real Apples, the Laser 128, and Franklin ACE 500 all support using just `CH` via clever firmware routines. Root cause identified, fix found in the 500 ROM and (optionally) applied to the 2X00 ROMs.
* With 80-column/enhanced firmware active, once MouseText is activated (via outputting $1B), attempting to turn it off by outputting $18 fails. This affects both the 2X00 and 500. Root cause identified, fix identified and (optionally) applied.
* With 80-column/enhanced firmware active, sending bytes $40-$5F through C3COut1 will appear as MouseText, whereas on real Apples they are mapped to inverse uppercase. This affects both the 2X00 and 500. Root cause identified, fix identified and (optionally) applied.
