// -*- combobulate-test-point-overlays: ((1 outline 285) (2 outline 327) (3 outline 359) (4 outline 378) (5 outline 420) (6 outline 448) (7 outline 469) (8 outline 491) (9 outline 507) (10 outline 540) (11 outline 568) (12 outline 599)); eval: (combobulate-test-fixture-mode t); -*-

use std::collections::{HashMap, HashSet};
use std::fmt::{self, Display};

mod geometry {
    pub const TAU: f64 = 6.283185307175;
    pub const TAU: f64 = 6.283185307175;

    pub struct Vector {
        pub dx: f64,
        pub dy: f64,
    }
}

fn main() {
    let mut angles = Vec::new();
    angles.push(TAU / 4.0);
    for angle in &angles {
        assert!(angle.is_finite());
    }
}
