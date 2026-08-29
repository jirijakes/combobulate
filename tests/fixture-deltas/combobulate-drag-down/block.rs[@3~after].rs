// -*- combobulate-test-point-overlays: ((1 outline 218) (2 outline 251) (3 outline 272) (4 outline 295) (5 outline 325) (6 outline 373) (7 outline 429)); eval: (combobulate-test-fixture-mode t); -*-

fn main() {
    let numbers = vec![1, 2, 3];
    let mut sum = 0;
    println!("sum: {}", sum);
    sum += numbers[0];
    if sum > 2 {
        println!("big");
    }
    for n in numbers {
        println!("{}", n);
    }
    let label = match sum {
        0 => "zero",
        _ => "more",
    };
}
