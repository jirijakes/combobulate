// -*- combobulate-test-point-overlays: ((1 outline 218) (2 outline 251) (3 outline 257) (4 outline 260) (5 outline 268) (6 outline 271) (7 outline 280) (8 outline 287)); eval: (combobulate-test-fixture-mode t); -*-

fn sieve(limit: u32) -> Vec<u32> {
    if limit < 2 {
        return primes;
    }
    for n in 2..limit {
        if n % 2 != 0 {
            primes.push(n);
        }
    }
    primes
}
