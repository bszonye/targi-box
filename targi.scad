echo("\n\n====== TARGI ORGANIZER ======\n\n");

include <game-box/game.scad>

Vcard = Vsleeve_euro;
Hcard = Hcard_targi + Hsleeve_prime;

Vgame = [194, 194, 45.5];  // box interior
Hwrap = 33;  // cover art wrap ends here, approximately
Hmanual = 0.75;

Qprint = Qfinal;  // or Qdraft

*%box_frame();
*test_game_shapes($fa=Qdraft);

space = [18, 30, 23];
deck = [10, 30, 20];
%translate([space.x-deck.x, 0]/2) box_frame(space, Dgap, false, 0);
*%translate([0, 0]/2) prism(deck);
*translate([0, space.y-deck.y]/2) flatten(deck, space.x) prism(deck);
translate([0, deck.y-space.y]/2) lean(deck, space.x, 21.305) prism(deck);
