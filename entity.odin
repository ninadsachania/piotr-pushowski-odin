package main

EntityFlags :: enum u8 {
    PUSHABLE = 1,
    PUSHER = 2,
    BLOCKING = 4,
}

EntityType :: enum u8 {
    NONE = 0,
    PLAYER,
    CRATE,
}

Entity :: struct {
    type: EntityType,
    x: i32,
    y: i32,
    vx: f32,
    vy: f32,
    spr: SpriteType,
    color: u8, // @DefaultValues = 7,
    flags: u8, // @DefaultValues = 0,
}

entity_draw :: proc(e: Entity, yoffset: int) {
    // @Uncomment draw_sprite(e.spr, .{xx (e.vx * CELL_WIDTH + 0.5), xx ((e.vy * CELL_HEIGHT + 0.5) + yoffset)}, pal[e.color]);
}

entity_update :: proc(e: ^Entity) {
    target_x: f32 = auto_cast e.x
    target_y: f32 = auto_cast e.y

    dx: f32 = target_x - e.vx
    dy: f32 = target_y - e.vy

    e.vx += dx * 30 * time_delta
    e.vy += dy * 30 * time_delta
}

entity_set_snap_pos :: proc(e: ^Entity, x: i32, y: i32) {
    e.x = x
    e.y = y
    e.vx = auto_cast x
    e.vy = auto_cast y
}

entity_has_flag :: proc(e: ^Entity, flag: EntityFlags) -> bool {
    if e == nil {
        return false
    }
    if e.flags & auto_cast flag != 0 {
        return true
    }
    return false
}
