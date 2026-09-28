# Prismforge Planner

Plan a Remnant II prism in the browser and get a **build code** that
[Prismforge](https://github.com/EX0Sk1tz/Remnant-2-PrismForge) imports in one step.

**Open the planner:** https://ex0sk1tz.github.io/prismforge-planner/

1. Pick the segments (standard, fusion, legendary), their levels and optional fed fragments, pending XP and a note.
2. Copy the build code (or a link that opens the page with your prism).
3. In Prismforge, select the prism, paste the code under **Build code** and press **Import**.
   Import replaces the prism's segments and fed fragments (and its XP, if the code has one) and asks first.

Prismforge's **Copy code** button does the reverse: it copies an existing prism as a code you can
load here with **Load code** and edit.

## Build code format

`PF1-` followed by base64url (no padding) of the raw-DEFLATE-compressed UTF-8 JSON:

```json
{ "v": 1, "n": "note", "xp": 1000, "s": [["CriticalDamage", 10], ["WeakspotDamageCriticalDamage", 20]], "f": [["ModDamage", 5]] }
```

- `s`: segments as `[row, level]`, level 0–100,000,000, at most 256.
- `f`: fed fragments as `[row, level]`, level 0–999, at most 128.
- `n` (note, up to 200 characters) and `xp` are optional; without `xp` the prism's XP stays unchanged.
- Rows are the game's data table row names (see Prismforge's `Data/SegmentCatalog.json`).

The format is implemented twice and must stay in sync: `index.html` here and `Game/BuildCode.cs` in Prismforge.

## Development

`index.html` is generated. Edit `src/index.template.html`, then run

```
powershell -ExecutionPolicy Bypass -File build.ps1
```

It injects the stat catalog from the Prismforge repository (by default `..\R2PrismRuntime-Development\Data\SegmentCatalog.json`;
pass `-Catalog <path>` otherwise). Run it again whenever the catalog changes.

Unofficial fan tool, not affiliated with Gunfire Games or Gearbox Publishing. MIT License, © 2026 EX0Sk1tz.
