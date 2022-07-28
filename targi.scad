echo("\n\n====== TARGI ORGANIZER ======\n\n");

include <game-box/game.scad>

Vcard = Vsleeve_euro;
Hcard = Hcard_targi + Hsleeve_prime;

Vgame = [194, 194, 45.5];  // box interior
Hwrap = 33;  // cover art wrap ends here, approximately
Hmanual = 0.75;

Qprint = Qfinal;  // or Qdraft

%box_frame();
test_game_shapes($fa=Qdraft);
