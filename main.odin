package main

import "core:fmt"



main :: proc() {
	fmt.println("Piotr Pushowski and the Crates")
}

Vector4 :: struct {
    // Wrong order?
    x: f32,
    y: f32,
    z: f32,
    w: f32,
}

U16_MAX : int : 65535
