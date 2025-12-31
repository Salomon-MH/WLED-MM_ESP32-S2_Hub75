// Back box for Waveshare RGB-Matrix P2.5 64x32
// Rear usable frame: 158 x 78 mm. [web:10]

panel_len_back    = 158;
panel_height_back = 78;

inner_depth    = 30;   // free space for electronics
frame_overlap  = 10;   // how far box slides over panel frame
wall           = 1;
bottom_thick   = 0.5;

slit_width     = 5;
slit_offset    = 30;   // from left corner
slit_depth     = 20;   // from open top downward

clearance      = 0.5;

inner_len      = panel_len_back  + 2*clearance;
inner_height   = panel_height_back + 2*clearance;
outer_len      = inner_len + 2*wall;
outer_height   = inner_height + 2*wall;
outer_depth    = bottom_thick + inner_depth + frame_overlap;

// simple rectangular clip
module side_clip() {
    clip_len   = 14;   // along X
    clip_thick = 0.8;  // into cavity (Y)
    clip_height = 6;   // vertical size
    cube([clip_len, clip_thick, clip_height], center=false);
}

module box_body() {
    difference() {
        // outer shell
        cube([outer_len, outer_height, outer_depth], center=false);

        // inner cavity (hollow)
        translate([wall, wall, bottom_thick])
            cube([inner_len, inner_height, inner_depth + frame_overlap], center=false);

        // cable slit at open/top side
        translate([
            wall + slit_offset,
            0,
            outer_depth - slit_depth
        ])
            cube([slit_width, wall + 0.6, slit_depth], center=false);
    }

    // ---- clips ----
    clip_len    = 14;
    clip_thick  = 0.8;

    // attach directly to inner faces (no gap):
    clip_y_inner_bottom = wall;                         // inner bottom wall
    clip_y_inner_top    = outer_height - wall - clip_thick; // inner top wall

    // Z: in the overlap zone near open side
    clip_z      = bottom_thick + inner_depth + 1;

    // X positions chosen away from the slit (center-ish)
    xpos_list = [outer_len * 0.35, outer_len * 0.65];

    // bottom long wall clips
    for (xp = xpos_list) {
        translate([xp - clip_len/2, clip_y_inner_bottom, clip_z])
            side_clip();
    }

    // top long wall clips
    for (xp = xpos_list) {
        translate([xp - clip_len/2, clip_y_inner_top, clip_z])
            side_clip();
    }
}

box_body();
