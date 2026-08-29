// -*- combobulate-test-point-overlays: ((1 outline 202) (2 outline 302) (3 outline 344) (4 outline 394) (5 outline 442) (6 outline 523) (7 outline 585)); eval: (combobulate-test-fixture-mode t); -*-

use std::collections::HashMap;

// this comment is not navigable
#[derive(Debug, Clone, PartialEq)]
struct Point {
    x: u32,
    y: u32,
}

fn distance(p: Point) -> u32 {
    p.x + p.y
}

enum Shape {
    Circle(u32),
    Square(u32),
}

impl Point {
    fn new(x: u32, y: u32) -> Self {
        Self { x, y }
    }
}

mod geometry {
    pub fn area() -> u32 {
        42
    }
}

macro_rules! square {
    ($x:expr) => {
        $x * $x
    };
}
