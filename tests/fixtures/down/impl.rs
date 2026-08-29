// -*- combobulate-test-point-overlays: ((1 outline 202) (2 outline 214) (3 outline 220) (4 outline 249) (5 outline 259) (6 outline 264) (7 outline 278)); eval: (combobulate-test-fixture-mode t); -*-

impl Server {
    fn new(host: String) -> Self {
        Self {
            host,
            port: 8080,
            max_connections: 100,
            verbose: false,
        }
    }
}
