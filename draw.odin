package main

import rl "vendor:raylib"

CELL_WIDTH  :: 16
CELL_HEIGHT :: 16

camera_x: i32 = 0
camera_y: i32 = 0

draw_sprite_one :: proc(tex: rl.Texture2D, spr: SpriteType, draw_pos: Vector2i, color: Vector4) {
    // @Stub. @Incomplete.
}

draw_sprite_two :: proc(tex: rl.Texture2D, spr: SpriteType, draw_rect: Rect, color: Vector4) {
    // @Stub. @Incomplete.
}

draw_sprite_three :: proc(tex: rl.Texture2D, si: SpriteIndex, draw_pos: Vector2i, color: Vector4) {
    pos := draw_pos
    pos.x += camera_x
    pos.y += camera_y

    src_rect := rl.Rectangle{
        x = f32(si.x * CELL_WIDTH),
        y = f32(si.y * CELL_HEIGHT),
        width = CELL_WIDTH,
        height = CELL_HEIGHT
    }

    dest_rect := rl.Rectangle{
        x = f32(pos.x),
        y = f32(pos.y),
        width = CELL_WIDTH,
        height = CELL_HEIGHT
    }

    c := rl.ColorFromNormalized([4]f32{color.x, color.y, color.z, color.w})

    rl.DrawTexturePro(tex, src_rect, dest_rect, [2]f32{ 0, 0 }, 0.0, c);
}

draw_sprite :: proc{draw_sprite_one, draw_sprite_two, draw_sprite_three}

draw_copy :: proc(tex: rl.Texture2D, src: Rect, draw_pos: Vector2i, color: Vector4) {
    pos := draw_pos
    pos.x += camera_x
    pos.y += camera_y

    src_rect := rl.Rectangle{
        x = f32(src.x),
        y = f32(src.y),
        width  = f32(src.width),
        height = f32(src.height)
    }

    dest_rect := rl.Rectangle{
        x = f32(pos.x),
        y = f32(pos.y),
        width  = f32(src.width),
        height = f32(src.height)
    }

    c := rl.ColorFromNormalized([4]f32{color.x, color.y, color.z, color.w})
    
    rl.DrawTexturePro(tex, src_rect, dest_rect, [2]f32{ 0, 0 }, 0.0, c)
}

draw_text :: proc(font: ^SpriteFont, draw_pos: Vector2i, color: Vector4, text: string) {
    draw_text_internal(font, draw_pos, color, text, false)
}

measure_text :: proc(font: ^SpriteFont, text: string) -> (int, int) {
    width, height := draw_text_internal(font, Vector2i{0, 0}, Vector4{1, 1, 1, 1}, text, true)
    return width, height
}

camera_set :: proc(x: int, y: int) {
    camera_x = auto_cast x
    camera_y = auto_cast y
}

camera_reset :: proc() {
    camera_x = 0
    camera_y = 0
}

@(private="file")
draw_text_internal :: proc(font: ^SpriteFont, draw_pos: Vector2i, color: Vector4, text: string, measure_only: bool) -> (int, int) {
    pos := draw_pos
    pos.x += camera_x
    pos.y += camera_y

    pos_x := cast(int)draw_pos.x
    pos_y := cast(int)draw_pos.y
    
    total_width := 0
    total_height := font.glyph_height + font.spacing_y

    for i in 0..=len(text) - 1 {
        c := text[i]

        if c == '\n' {
            pos_y += font.glyph_height + font.spacing_y
            total_height += font.glyph_height + font.spacing_y
        }

        glyph_i: int = cast(int) c - cast(int) font.first_char // @Cast

        // Glyph not valid, or maybe its a space? Skip a space width
        if glyph_i < 0 || glyph_i >= len(font.glyphs) {
            pos_x += font.space_width + font.spacing_x
            total_width += font.space_width + font.spacing_x
            continue
        }

        glyph := font.glyphs[glyph_i]

        if !measure_only {
            draw_copy(arts, Rect{glyph.x, glyph.y, glyph.width, glyph.height}, Vector2i{auto_cast pos_x, auto_cast pos_y}, color)
        }

        pos_x += font.glyph_width + font.spacing_x
        total_width += font.glyph_width + font.spacing_x   
    }

    return total_width, total_height
}
