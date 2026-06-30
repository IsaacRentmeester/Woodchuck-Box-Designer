# Woodchuck USA — Custom Box Designer

## Project Overview
An interactive 3D box configurator built for Woodchuck USA's packaging sales process. Clients design their custom wood packaging and submit a quote request via email. Built as a single self-contained HTML file — no build tools, no dependencies, no backend required.

## File Structure
```
woodchuck-box-designer.html   — Main deliverable (all HTML + CSS + JS in one file)
wood-quoting-tool.html        — Earlier pricing/quoting tool
IronLog.html                  — Separate internal tool
CLAUDE.md                     — This file
```

## Architecture
The designer is a single HTML file (~1200 lines) with everything inline:
- **CSS** — CSS variables for Woodchuck brand colors (green, gold, cream), responsive layout
- **Canvas renderer** — Custom 2D isometric renderer (no WebGL/Three.js). Uses painter's algorithm with backface culling for solid-looking 3D boxes.
- **Box builders** — Each lid type (hinged, clamshell, slide, settop, droptop, crate) has its own `buildXxx(w,h,dp,add)` function that pushes face quads into `allFaces[]`
- **Animation** — Cubic ease-out over 110 frames for lid open/close. Spring physics removed in favor of guaranteed no-overshoot approach.
- **Particle system** — Gold spark particles on lid close, staggered wave emission

## Box Types (matching Woodchuck catalog)
| Key | Name | Description |
|-----|------|-------------|
| `hinged` | Hinged Top | Classic flip-open, hinge at back |
| `clamshell` | Clamshell | Opens from center, equal halves |
| `slide` | Slide Top | Lid slides backward in z-direction |
| `settop` | Set Top | Lid lifts straight up |
| `droptop` | Drop Top | Thin top panel swings up from front |
| `crate` | Rustic Crate | Open slatted crate, no lid |

## Key Functions
- `drawBox()` — Main render loop. Builds face list, sorts by depth, renders with backface culling
- `buildXxx(w,h,dp,add)` — Box geometry builders. `add(verts, nx, ny, nz)` pushes a quad face
- `startLidAnim()` — Cubic ease-out animation for lid. `lidA` = current angle (0=closed, π*0.82=open)
- `rotateLid(x,y,z,bh,dp,la)` — Rotates a vertex around the lid hinge axis
- `emitSparks(x,y,count,big)` — Spawns gold particle burst at canvas coordinates
- `P(key,val,el,quiet)` — State setter. Updates `C` config object, redraws, shows toast
- `toggleLid()` — Flips `C.open`, starts animation
- `sparkOnClose()` — Fires achievement spark burst when lid seats (lidA < startA * 0.02)

## State Object
```js
const C = {
  bt: 'hinged',      // box type
  wood: 'birch',     // wood species
  fin: 'natural',    // finish
  sz: 'md',          // size (sm/md/lg)
  hw: 'gold',        // hardware color
  int: 'none',       // interior insert
  pl: 'top',         // logo placement
  engrave: '',       // engraving text
  logo: null,        // uploaded Image object
  open: false,       // lid open state
  qty: 100           // order quantity
}
```

## Brand Colors
```css
--green: #3d4f43    /* primary brand green */
--gold: #C8A060     /* accent gold */
--cream: #F8F4EE    /* background */
```

## Wood Species
Birch, Maple, Walnut Maple, Mahogany, Cedar, Walnut — each with species-specific grain config in `GRAIN_CFG`

## Finishes
Natural, Golden Oak stain, Mahogany stain, Walnut stain, Black paint, White paint

## Interior Inserts
None (raw wood), Eco-Foam, PU Foam, Velvet Flocked, Wood Inserts, Excelsior

## Common Tasks
- **Add a new box type**: Create `buildNewType(w,h,dp,add)`, add to switch in `drawBox()`, add button in `.btg`, update `NM.bt` and `TOASTS.bt`
- **Change lid speed**: Adjust `easDur` in `startLidAnim()` (currently 110 frames ~1.8s)
- **Add a new wood species**: Add to `WB` color map, `GRAIN_CFG`, and `NM.wood`
- **Update sizing**: Edit `DIMS` object (w/h/d in relative units)
- **Update email recipient**: Search for `mailto:` in the file
