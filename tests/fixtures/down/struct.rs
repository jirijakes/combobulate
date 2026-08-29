// -*- combobulate-test-point-overlays: ((1 outline 154) (2 outline 168) (3 outline 174) (4 outline 180)); eval: (combobulate-test-fixture-mode t); -*-

struct Server {
    host: String,
    port: u16,
    max_connections: u32,
    verbose: bool,
}
