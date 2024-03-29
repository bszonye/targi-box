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
    module slant_well(size, height=undef, rise=0, r=Rint) {
        v = volume(size, height);
        hull() {
            raise(rise) prism(v, height=v.z-rise+Dcut, r=r);
            translate([0, -rise/2]) prism([v.x, v.y-rise, v.z], r=r);
        }
    }
    hfloor = Hfloor/2;
    hdiv = Vgoods.z/2;
    hrise = 18;
    dslot = (Vgoods.x - 4*Dwall)/3;
    vslot = [dslot, 48, Vgoods.z-hfloor];
    vmid = [dslot, Dwall+2*Rint+EPSILON, Vgoods.z-hdiv-hfloor+Dcut];
    colorize(color) difference() {
        prism(Vgoods, r=Rext);
        for (i=[-1:+1]) translate([i*(vslot.x+Dwall), 0, hfloor]) {
            translate([0, Vgoods.y/2 - 3/2*Dwall - vslot.y, hdiv]) prism(vmid);
            for (j=[-1,+1]) translate([0, j*(Vgoods.y/2-vslot.y/2-Dwall)])
                slant_well(vslot, height=Vgoods.z-hfloor, rise=hrise-j);
        }
    }
}

Vpoints = [Vgame.x - 2*Vtray.x, Vgame.y - Vtray.x, Hceiling/2];
module points_tray(size=Vpoints, height=undef, color=undef) {
    v = volume(size, height);
    hwell = v.z - Hfloor;
    r = 2*Rext;
    scoop_tray(Vpoints, grid=[1, 4], rscoop=r, lip=hwell-r, color=color);
}

module organizer() {
    %box_frame();

    for (i=[0,1]) {
        origin = area(Vtray)/2 - area(Vgame)/2 - area(Dgap);
        translate(volume(origin + [i*(Dgap+Vtray.x), 0], Hfoot))
            card_tray(cards=Ntribe+Ntborder);
    }
    rotate(90) {
        origin = area(Vtray)/2 - area(Vgame)/2 - area(Dgap);
        translate([-origin.x, origin.y, Hfoot]) {
            card_tray(height=Hdune, cards=Ndune);
            raise(Hdune+Dgap) card_tray(height=Hgoods, cards=Ngoods);
        }
    }
    for (i=[0,1]) {
        ogoods = area(Dgap) + area(Vgame)/2 - area(Vgoods)/2;
        translate([-ogoods.x, ogoods.y, i*(Vgoods.z+Dgap)]) goods_tray();
        opoints = area(Dgap) + area(Vgame)/2 - area(Vpoints)/2;
        translate([opoints.x, -opoints.y, i*(Vpoints.z+Dgap)]) points_tray();
    }
}

organizer();
*test_game_shapes($fa=Qdraft);

*card_tray(cards=Ntribe+Ntborder, $fa=Qprint);
*card_tray(height=Hgoods, cards=Ngoods+Ngborder, $fa=Qprint);
*card_tray(height=Hdune, cards=Ndune, $fa=Qprint);
*tray_foot($fa=Qprint);
*goods_tray($fa=Qprint);
*points_tray($fa=Qprint);
