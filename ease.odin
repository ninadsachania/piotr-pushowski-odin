package main

import "core:math"

EaseFunc :: enum {
    LINEAR,
    SINE_IN,
    SINE_OUT,
    SINE_IN_OUT,
    QUAD_IN,
    QUAD_OUT,
    QUAD_IN_OUT,
    CUBIC_IN,
    CUBIC_OUT,
    CUBIC_IN_OUT,
    QUARTIC_IN,
    QUARTIC_OUT,
    QUARTIC_IN_OUT,
    QUANTIC_IN,
    QUANTIC_OUT,
    QUANTIC_IN_OUT,
    EXPO_IN,
    EXPO_OUT,
    EXPO_IN_OUT,
    CIRC_IN,
    CIRC_OUT,
    CIRC_IN_OUT,
    BACK_IN,
    BACK_OUT,
    BACK_IN_OUT,
    ELASTIC_IN,
    ELASTIC_OUT,
    ELASTIC_IN_OUT,
    BOUNCE_IN,
    BOUNCE_OUT,
    BOUNCE_IN_OUT,
}

ease_interp :: proc(func : EaseFunc, start: i32, end: i32, t: f32) -> i32
{
    // @Stub
    return 0
}

// Map t so that:
// t < min = 0
// t > max = 1
// min < t < max = mapped to 0..1
ease_range_map :: proc(t: f32, min: f32, max: f32) -> f32 {
    if t < min { return 0 }
    if t > max { return 1 }

    return (t - min) / (max - min)
}

// @Scope #scope_file

HALF_PI :: (math.PI / 2.0)

linear :: proc(t: f32) -> f32 {
    return t
}

sine_in :: proc(t: f32) -> f32 {
    return math.sin((t - 1) * HALF_PI) + 1
}

sine_out :: proc(t: f32) -> f32 {
    return math.sin(t * HALF_PI)
}

sine_in_out :: proc(t: f32) -> f32 {
    return 0.5 * (1 - math.cos(t * math.PI))
}

quad_in :: proc(t: f32) -> f32 {
    return t * t
}

quad_out :: proc(t: f32) -> f32 {
    return -(t * (t - 2))
}

quad_in_out :: proc(t: f32) -> f32 {
    if t < 0.5 {
        return 2 * t * t
    }
    else {
        return (-2 * t * t) + (4 * t) - 1
    }
}

cubic_in :: proc(t: f32) -> f32 {
    return t * t * t
}

cubic_out :: proc(t: f32) -> f32 {
    f : f32 = t - 1
    return (f * f * f) + 1
}

cubic_in_out :: proc(t: f32) -> f32 {
    if t < 0.5 {
        return 4 * t * t * t
    }
    else {
        f : f32 = (2 * t) - 2
        return (0.5 * f * f * f) + 1
    }
}

quartic_in :: proc(t: f32) -> f32 {
    return t * t * t * t
}

quartic_out :: proc(t: f32) -> f32 {
    f : f32 = t - 1
    return (f * f * f * (1 - t)) + 1
}

quartic_in_out :: proc(t: f32) -> f32 {
    if t < 0.5 {
        return 8 * t * t * t * t
    }
    else {
        f : f32 = t - 1
        return (-8 * f * f * f * f) + 1
    }
}

quantic_in :: proc(t: f32) -> f32 {
    return t * t * t * t * t
}

quantic_out :: proc(t: f32) -> f32 {
    f : f32 = t - 1
    return (f * f * f * f * f) + 1
}

quantic_in_out :: proc(t: f32) -> f32 {
    if t < 0.5 {
        return 16 * t * t * t * t * t
    }
    else {
        f : f32 = (2 * t) - 2
        return (0.5 * f * f * f * f * f) + 1
    }
}

expo_in :: proc(t: f32) -> f32 {
    if t == 0.0 {
        return t
    } else {
        return math.pow(2, 10 * (t - 1))
    }
}

expo_out :: proc(t: f32) -> f32 {
    if t == 1.0 { return t} else { return 1 - math.pow(2, -10 * t) }
}

expo_in_out :: proc(t: f32) -> f32 {
    if t == 0.0 || t == 1.0 {
        return t
    }

    if t < 0.5 {
        return 0.5 * math.pow(2, (20 * t) - 10)
    }
    else {
        return (-0.5 * math.pow(2, (-20 * t) + 10)) + 1
    }
}

circ_in :: proc(t: f32) -> f32 {
    return 1 - math.sqrt(1 - (t * t))
}

circ_out :: proc(t: f32) -> f32 {
    return math.sqrt((2 - t) * t)
}

circ_in_out :: proc(t: f32) -> f32 {
    if t < 0.5 {
        return 0.5 * (1 - math.sqrt(1 - (4 * (t * t))))
    }
    else {
        return 0.5 * (math.sqrt(-((2 * t) - 3) * ((2 * t) - 1)) + 1)
    }
}

back_in :: proc(t: f32) -> f32 {
    return (t * t * t) - (t * math.sin(t * math.PI))
}

back_out :: proc(t: f32) -> f32 {
    f : f32 = 1 - t
    return 1 - ((f * f * f) - (f * math.sin(f * math.PI)))
}

back_in_out :: proc(t: f32) -> f32 {
    if t < 0.5 {
        f : f32 = 2 * t
        return 0.5 * ((f * f * f) - (f * math.sin(f * math.PI)))
    }
    else {
        f : f32 = 1 - ((2 * t) - 1)
        return (0.5 * (1 - ((f * f * f) - (f * math.sin(f * math.PI))))) + 0.5
    }
}

elastic_in :: proc(t: f32) -> f32 {
    return math.sin(13 * HALF_PI * t) * math.pow(2, 10 * (t - 1))
}

elastic_out :: proc(t: f32) -> f32 {
    return (math.sin(-13 * HALF_PI * (t + 1)) * math.pow(2, -10 * t)) + 1
}

elastic_in_out :: proc(t: f32) -> f32 {
    if t < 0.5 {
        return 0.5 * math.sin(13 * HALF_PI * (2 * t)) * math.pow(2, 10 * ((2 * t) - 1))
    }
    else {
        return 0.5 * ((math.sin(-13 * HALF_PI * (((2 * t) - 1) + 1)) * math.pow(2, -10 * ((2 * t) - 1))) + 2)
    }
}

bounce_in :: proc(t: f32) -> f32 {
    return 1 - bounce_out(1 - t)
}

bounce_out :: proc(t: f32) -> f32 {
    if t < 4 / 11.0 {
        return (121 * t * t) / 16.0
    }
    else if t < 8 / 11.0 {
        return (363 / 40.0 * t * t) - (99 / 10.0 * t) + (17 / 5.0)
    }
    else if t < 9 / 10.0 {
        return (4356 / 361.0 * t * t) - (35442 / 1805.0 * t) + (16061 / 1805.0)
    }
    else {
        return (54 / 5.0 * t * t) - (513 / 25.0 * t) + (268 / 25.0)
    }
}

bounce_in_out :: proc(t: f32) -> f32 {
    if t < 0.5 {
        return 0.5 * bounce_in(t * 2)
    }
    else {
        return (0.5 * bounce_out((t * 2) - 1)) + 0.5
    }
}

value :: proc(func: EaseFunc, t: f32) -> f32 {
    switch func {
        case .LINEAR: return linear(t)
        case .SINE_IN: return sine_in(t)
        case .SINE_OUT: return sine_out(t)
        case .SINE_IN_OUT: return sine_in_out(t)
        case .QUAD_IN: return quad_in(t)
        case .QUAD_OUT: return quad_out(t)
        case .QUAD_IN_OUT: return quad_in_out(t)
        case .CUBIC_IN: return cubic_in(t)
        case .CUBIC_OUT: return cubic_out(t)
        case .CUBIC_IN_OUT: return cubic_in_out(t)
        case .QUARTIC_IN: return quartic_in(t)
        case .QUARTIC_OUT: return quartic_out(t)
        case .QUARTIC_IN_OUT: return quartic_in_out(t)
        case .QUANTIC_IN: return quantic_in(t)
        case .QUANTIC_OUT: return quantic_out(t)
        case .QUANTIC_IN_OUT: return quantic_in_out(t)
        case .EXPO_IN: return expo_in(t)
        case .EXPO_OUT: return expo_out(t)
        case .EXPO_IN_OUT: return expo_in_out(t)
        case .CIRC_IN: return circ_in(t)
        case .CIRC_OUT: return circ_out(t)
        case .CIRC_IN_OUT: return circ_in_out(t)
        case .BACK_IN: return back_in(t)
        case .BACK_OUT: return back_out(t)
        case .BACK_IN_OUT: return back_in_out(t)
        case .ELASTIC_IN: return elastic_in(t)
        case .ELASTIC_OUT: return elastic_out(t)
        case .ELASTIC_IN_OUT: return elastic_in_out(t)
        case .BOUNCE_IN: return bounce_in(t)
        case .BOUNCE_OUT: return bounce_out(t)
        case .BOUNCE_IN_OUT: return bounce_in_out(t)
        case: return t
    }
}

round_to_int :: proc(f: f32) -> int {
    if f < 0.0 {
        return cast (int)(f - 0.5)
    } else {
        return cast (int)(f + 0.5)
    }    
}

round_to_uint :: proc(f: f32) -> u64 {
    return cast (u64)(f + 0.5)
}
