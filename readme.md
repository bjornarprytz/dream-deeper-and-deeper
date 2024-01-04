# dream-deeper-and-deeper

## Themes

- Dream
- "Deeper and deeper"
- Stipulation:
  - Procedural art
  - Kid-friendly

## Concept #1 Fractal Tablecloth

"An infinite walking-sim in mundane, procedural fractal dreamscapes"

The player plays a character of a certain color (let's say red). They inhabit the flat world of a tablecloth. That is, it's inside the pattern itself. The world will have many colors, but the player color is reserved, and the background is white.

This flatworld has some movement, and a few creatures here and there. And it's dripping with magic. Spillage from food and drinks are magic in this realm.

### Procedural Generation

Each world will have its "fauna" of shapes (circle, square, triangle, maybe other polygons?). A 3 color palette of pastelle is chosen randomly. The fauna will have some simple AI to decide movement. Maybe some creatures are interested in the player, and maybe some flock together. Maybe others are dormant until something happens. They should all react to the player somehow, either by running away, or following. There is no violence in this game. Magic can affect the world, but never kill anything.

Movement should be very relaxed at first, but as the player moves deeper into the fractal, the parameters get increasingly volatile

Transitions between the worlds should be related to the magic. Maybe the player needs to fill a few flasks of paint in order to draw the portal they need. Maybe they get to mix the colors for the next palette, and the palette is used as the seed for the procedural generation.

#### Fauna

- Tri
  - Inquisitive
  - Mischievous
  - Loner
  - Dances
- Quad
  - Flocking
  - Dances
  - Grasses on Flowers
- Circ
  - Sings
  - Picks Flowers for braiding
- Bug
  - Buzzes around on vector paths
  - Lands on flowers
  - Interaction with the player?

#### Flora

## TODO

- Palette
  - Pastel
    - https://colorhunt.co/palette/ecee818ddfcb82a0d8edb7ed
    - https://colorhunt.co/palette/fd8a8af1f7b5a8d1d19ea1d4
    - https://colorhunt.co/palette/9adcfffff89affb2a6ff8aae
- Generation
  - Clean up stragglers outside chunk bounds
- Behaviour
  - Flocking
  - Interact with the player
  - Speed
- Player
  - Appearance: Catterpillar (Like Mario Chomp Chomp)
- Mechanics
  - Gather color drops
  - Create portal

### Behaviour

- Critters
  - Bug
    - Escape sudden movement
      - How sudden depends on remaining energy (high energy = fast reaction)
  - Tri
    - Meander
    - Investigate
      - Dance
      - Pick Flower
  - Quad
    - Meander
    - Interact
      - Eat (Flower)
        - Poop
      - Flock (Quad)
  - Circ
    - Pick Flowers
    - Plant Seeds
    - Interact
      - Sing (Circ, Player, Tri)
      - Feed (Quad)
  - Seeds
    - Seeds can be "picked up" by bugs and critters. They stick to their bodies, and take root after a few seconds
    - Create Portal

- Push release with `./push_release.sh`

### Nice to have

- Background Pattern
  - Apply palette
  - "World Space" the weave-pattern shader
  - Random/varied pattern
- Generation
  - Organic meadows
- Palette for bugs

### Extra

- Rename the game
- Write a short description
- Make a nice cover image (630x500)
- Add screenshots (recommended: 3-5)
- Pick a genre
- Add a tag or two
- Publish a devlog on instagram

### Meta

- Figure out how to develop for mobile
  - How to use the on-screen keyboard
