package main

import rl "vendor:raylib"

// https://lospec.com/palette-list/purplemorning8
pal := [8]Vector4{
    Vector4{12 / 255.0, 7 / 255.0, 40 / 255.0, 1},         // 0
    Vector4{28 / 255.0, 23 / 255.0, 68 / 255.0, 1},        // 1
    Vector4{44 / 255.0, 50 / 255.0, 87 / 255.0, 1},        // 2
    Vector4{89 / 255.0, 76 / 255.0, 106 / 255.0, 1},       // 3
    Vector4{160 / 255.0, 91 / 255.0, 118 / 255.0, 1},      // 4
    Vector4{215 / 255.0, 118 / 255.0, 107 / 255.0, 1},     // 5
    Vector4{225 / 255.0, 178 / 255.0, 140 / 255.0, 1},     // 6
    Vector4{222 / 255.0, 231 / 255.0, 173 / 255.0, 1},     // 7
}

SpriteType :: enum {
    NONE,
    WALL,
    WALL_EDGE,
    GROUND,
    PLAYER,
    CRATE,
    CRATE_SLOT,
    DOOR_CLOSED,
    DOOR_OPEN,
    UI_HAND,
    FADE_IN_SLANT,
    FADE_OUT_SLANT,
    FADE_SOLID,
    GRASS1,
    GRASS2,
    GRASS3,
    GRASS4,
    GRASS5,
    GRASS6,
    GRASS7,
    GRASS8,
    GRASS9,
    GRASS10,
}

SpriteIndex :: struct {
    x: u16,
    y: u16,
}

Rect :: struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32,
}

Vector2i :: struct {
    x: i32,
    y: i32,
}

SpriteFont :: struct {
    first_char: u8,
    glyph_width: int,
    glyph_height: int,
    spacing_x: int,
    spacing_y: int,
    space_width: int,
    glyphs: [dynamic] Rect,
}

sprites: [64] SpriteIndex
sprite_fill_corners: [16] SpriteIndex
sprite_fill_sides: [16] SpriteIndex
sprite_title_art: Rect
sprite_title_text1: Rect
sprite_title_text2: Rect
sprite_slider_tag: Rect
sprite_slider_bar: Rect
sprite_checkbox_off: Rect
sprite_checkbox_on: Rect

sprite_logo: Rect

sprite_help1: Rect
sprite_help2: Rect

font_expire: SpriteFont

arts: rl.Texture2D
logo: rl.Texture2D

// @Uncomment sound_step: *Mixer_Sound_Data
// @Uncomment sound_push: *Mixer_Sound_Data
// @Uncomment sound_option: *Mixer_Sound_Data
// @Uncomment sound_select: *Mixer_Sound_Data
// @Uncomment sound_cancel: *Mixer_Sound_Data
// @Uncomment sound_door_open: *Mixer_Sound_Data
// @Uncomment sound_door_close: *Mixer_Sound_Data
// @Uncomment sound_win: *Mixer_Sound_Data
// @Uncomment sound_scene_swish: *Mixer_Sound_Data
// @Uncomment sound_drawer_open: *Mixer_Sound_Data
// @Uncomment sound_drawer_snap: *Mixer_Sound_Data

shader_present: rl.Shader

sprite_get_index :: proc(spr :SpriteType) -> SpriteIndex {
    si: SpriteIndex = sprites[cast (int) spr]
    return si
}

set_sprite :: proc(type: SpriteType, cx: int, cy: int) {
    sprites[cast (int) type].x = auto_cast cx
    sprites[cast (int) type].y = auto_cast cy
}

set_font :: proc(font: ^SpriteFont, first_char: u8, last_char: u8, pos: Vector2i, col: int, glyph_width: int, glyph_height: int, spacing_x: int, spacing_y: int, space_width: int) {
    if font == nil { return }

    font.first_char = first_char
    font.glyph_width = glyph_width
    font.glyph_height = glyph_height
    font.spacing_x = spacing_x
    font.spacing_y = spacing_y
    font.space_width = space_width

    char_count := cast(int) last_char - cast(int)first_char + 1

    clear_dynamic_array(&font.glyphs)

    glyph_x := pos.x
    glyph_y := pos.y
    glyph_col := 0

    for i in 0..=(char_count - 1) {
        if i != 0 && i % col == 0 {
            glyph_x = pos.x
            glyph_y += auto_cast glyph_height
        }

        glyph_rect: Rect
        glyph_rect.x = glyph_x
        glyph_rect.y = glyph_y
        glyph_rect.width = auto_cast glyph_width
        glyph_rect.height = auto_cast glyph_height

        append(&font.glyphs, glyph_rect)

        glyph_x += auto_cast glyph_width
    }

}

assets_init :: proc() {
    arts = rl.LoadTexture("res/arts.png")
    logo = rl.LoadTexture("res/logo_trans.png")

    set_sprite(.NONE, U16_MAX, U16_MAX)

    set_sprite(.WALL, 0, 0)
    set_sprite(.WALL_EDGE, 0, 1)
    set_sprite(.GROUND, 0, 10)
    set_sprite(.PLAYER, 1, 0)
    set_sprite(.CRATE, 2, 0)
    set_sprite(.CRATE_SLOT, 3, 0)
    set_sprite(.DOOR_CLOSED, 0, 2)
    set_sprite(.DOOR_OPEN, 0, 3)
    
    set_sprite(.UI_HAND, 16, 6)
    set_sprite(.FADE_IN_SLANT, 17, 6)
    set_sprite(.FADE_SOLID, 18, 6)
    set_sprite(.FADE_OUT_SLANT, 19, 6)

    set_sprite(.GRASS1, 4, 0)
    set_sprite(.GRASS2, 5, 0)
    set_sprite(.GRASS3, 6, 0)
    set_sprite(.GRASS4, 7, 0)
    set_sprite(.GRASS5, 8, 0)
    set_sprite(.GRASS6, 9, 0)
    set_sprite(.GRASS7, 10, 0)
    set_sprite(.GRASS8, 11, 0)
    set_sprite(.GRASS9, 12, 0)
    set_sprite(.GRASS10, 13, 0)

    for v, i in sprite_fill_corners {
        sprite_fill_corners[i].x = 0
        sprite_fill_corners[i].y = 6
    }

    for v, i in sprite_fill_sides {
        sprite_fill_sides[i].x = 0
        sprite_fill_sides[i].y = 7
    }

    sprite_fill_corners[0b0000].x = 0
    sprite_fill_corners[0b0001].x = 1
    sprite_fill_corners[0b0010].x = 2
    sprite_fill_corners[0b0011].x = 3
    sprite_fill_corners[0b0100].x = 4
    sprite_fill_corners[0b0101].x = 5
    sprite_fill_corners[0b0110].x = 6
    sprite_fill_corners[0b0111].x = 7
    sprite_fill_corners[0b1000].x = 8
    sprite_fill_corners[0b1001].x = 9
    sprite_fill_corners[0b1010].x = 10
    sprite_fill_corners[0b1011].x = 11
    sprite_fill_corners[0b1100].x = 12
    sprite_fill_corners[0b1101].x = 13
    sprite_fill_corners[0b1110].x = 14
    sprite_fill_corners[0b1111].x = 15

    sprite_fill_sides[0b0000].x = 0
    sprite_fill_sides[0b0001].x = 1
    sprite_fill_sides[0b0010].x = 2
    sprite_fill_sides[0b0011].x = 3
    sprite_fill_sides[0b0100].x = 4
    sprite_fill_sides[0b0101].x = 5
    sprite_fill_sides[0b0110].x = 6
    sprite_fill_sides[0b0111].x = 7
    sprite_fill_sides[0b1000].x = 8
    sprite_fill_sides[0b1001].x = 9
    sprite_fill_sides[0b1010].x = 10
    sprite_fill_sides[0b1011].x = 11
    sprite_fill_sides[0b1100].x = 12
    sprite_fill_sides[0b1101].x = 13
    sprite_fill_sides[0b1110].x = 14
    sprite_fill_sides[0b1111].x = 15

    sprite_title_art = Rect{0, 140, 463, 338}
    sprite_title_text1 = Rect{236, 0, 276, 56}
    sprite_title_text2 = Rect{306, 56, 206, 38}

    sprite_slider_tag = Rect{256, 116, 5, 8}
    sprite_slider_bar = Rect{262, 116, 23, 8}
    sprite_checkbox_off = Rect{288, 115, 10, 10}
    sprite_checkbox_on = Rect{304, 115, 10, 10}

    sprite_help1 = Rect{320, 96, 44, 13}
    sprite_help2 = Rect{320, 112, 55, 15}

    sprite_logo = Rect{0, 0, 1024, 1024}

    set_font(&font_expire, '!', 'z', Vector2i{0, 485}, 32, 9, 9, -1, 0, 6)

    // @Uncomment sound_step = audio_load("res/footstep.wav")
    // @Uncomment sound_push = audio_load("res/push.wav")
    // @Uncomment sound_option = audio_load("res/option.wav")
    // @Uncomment sound_select = audio_load("res/select.wav")
    // @Uncomment sound_cancel = audio_load("res/cancel.wav")
    // @Uncomment sound_door_open = audio_load("res/door_open.wav")
    // @Uncomment sound_door_close = audio_load("res/door_close.wav")
    // @Uncomment sound_win = audio_load("res/level_done.wav")
    // @Uncomment sound_scene_swish = audio_load("res/swish.wav")
    // @Uncomment sound_drawer_open = audio_load("res/drawer_open.wav")
    // @Uncomment sound_drawer_snap = audio_load("res/drawer_snap.wav")

    // @Uncomment shader_present.gl_handle   = get_shader_program(SHADER_PRESENT)
    // @Uncomment shader_present.alpha_blend = false
}
