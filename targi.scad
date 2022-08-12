echo("\n\n====== TARGI ORGANIZER ======\n\n");

include <game-box/game.scad>

Vcard = Vsleeve_euro;
Hcard = Hcard_targi + Hsleeve_prime;

Vgame = [194, 194, 45.5];  // box interior
Hwrap = 33;  // cover art wrap ends here, approximately
Hmanual = 0.75;

Hceiling = floor(Vgame.z - Hmanual);
Htray = Hceiling - Hfoot;

Ntribe = 45;  // cards in each tribe deck
Ntborder = 10;  // border cards in the tribe deck tray
Ngoods = 24;  // cards in goods deck (with expansion)
Ngborder = 6;  // border cards in the goods deck tray
Ndune = 20;  // cards in sand dune deck

// distribute extra room evenly between goods & dune decks
Hdecks = Hcard * (Ngoods + Ngborder + Ndune);
headroom = (Htray - 2*Hfloor - Hdecks) / 2;
Hdune = round(Hcard * Ndune + headroom) + Hfloor;
Hgoods = Htray - Hdune;
echo(Hgoods=Hgoods, Hdune=Hdune, total=Hgoods+Hdune);

Qprint = Qfinal;  // or Qdraft

Vgoods = volume(Vgame.y - Vtray.y, Hceiling/2);
module goods_tray(color=undef) {
    vslot = [(Vgoods.x - 4*Dwall)/3, (Vgoods.y - 3*Dwall)/2];
    echo(Vgoods=Vgoods, vslot=vslot);
    colorize(color) difference() {
        prism(Vgoods, r=Rext);
        hbot = Hfloor/2;
        hdiv = Vgoods.z/2;
        for (i=[-1:+1]) translate([i*(vslot.x+Dwall), 0]) {
            raise(hdiv) prism([vslot.x, Dwall+2*Rint+EPSILON, hdiv+Dcut]);
            for (j=[-1/2,+1/2]) translate([0, j*(vslot.y+Dwall)])
                raise(hbot) prism(vslot, height=Vgoods.z-hbot+Dcut, r=Rint);
        }
    }
}

Vpoints = [Vgame.x - 2*Vtray.x, Vtray.y, Hceiling/2];
module points_tray(color=undef) {
    vwell = [Vpoints.x - 2*Dwall, (Vpoints.y - 4*Dwall)/3, Vpoints.z - Hfloor];
    rscoop = 2*Rext;
    echo(Vpoints=Vpoints, vwell=vwell, rscoop=rscoop);
    colorize(color) difference() {
        prism(Vpoints, r=Rext);
        for (i=[-1:+1]) translate([0, i*(vwell.y+Dwall), Hfloor])
            scoop_well(vwell, rscoop=rscoop, lip=vwell.z-rscoop);
    }
}

module organizer() {
    %box_frame();

    module corner_tray(height=undef, cards=0) {
        origin = area(Vtray)/2 - area(Vgame)/2 - area(Dgap);
        translate(volume(origin, Hfoot))
            card_tray(height=height, cards=cards);
    }
    for (i=[-1,+1]) scale([i, 1]) corner_tray(cards=Ntribe+Ntborder);
    rotate(-90) {
        corner_tray(height=Hdune, cards=Ndune);
        raise(Hdune+Dgap) corner_tray(height=Hgoods, cards=Ngoods);
    }
    for (i=[0,1]) {
        ogoods = area(Dgap) + area(Vgame)/2 - area(Vgoods)/2;
        translate(volume(ogoods, i*(Vgoods.z+Dgap))) goods_tray();
        opoints = [0, Vpoints.y/2 - Vgame.y/2];
        translate(volume(opoints, i*(Vpoints.z+Dgap))) points_tray();
    }
}

*organizer();
*test_game_shapes($fa=Qdraft);

*card_tray(cards=Ntribe+Ntborder, $fa=Qprint);
*card_tray(height=Hgoods, cards=Ngoods+Ngborder, $fa=Qprint);
*card_tray(height=Hdune, cards=Ndune, $fa=Qprint);
*tray_foot($fa=Qprint);
*goods_tray($fa=Qprint);
points_tray($fa=Qprint);
