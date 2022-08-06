echo("\n\n====== TARGI ORGANIZER ======\n\n");

include <game-box/game.scad>

Vcard = Vsleeve_euro;
Hcard = Hcard_targi + Hsleeve_prime;

Vgame = [194, 194, 45.5];  // box interior
Hwrap = 33;  // cover art wrap ends here, approximately
Hmanual = 0.75;

Htray = floor(Vgame.z - Hmanual) - Hfoot;

Ntribe = 45;  // cards in each tribe deck
Ntborder = 10;  // border cards in the tribe deck tray
Ngoods = 24;  // cards in goods deck (with expansion)
Ngborder = 6;  // border cards in the goods deck tray
Ndune = 20;  // cards in sand dune deck

// distribute extra room evenly between goods & dune decks
Hstack = Hcard * (Ngoods + Ngborder + Ndune);
headroom = (Htray - 2*Hfloor - Hstack) / 2;
Hdune = round(Hcard * Ndune + headroom) + Hfloor;
Hgoods = Htray - Hdune;
echo(Hgoods=Hgoods, Hdune=Hdune, total=Hgoods+Hdune);

Qprint = Qfinal;  // or Qdraft

*%box_frame();
test_game_shapes($fa=Qdraft);

*card_tray($fa=Qprint);

*card_tray(cards=Ntribe+Ntborder, $fa=Qprint);
*card_tray(height=Hgoods, cards=Ngoods+Ngborder, $fa=Qprint);
*card_tray(height=Hdune, cards=Ndune, $fa=Qprint);
*tray_foot($fa=Qprint);
