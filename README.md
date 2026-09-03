# autobdd-test

#### purposes:
1. smoke test and demo the automagic power of xyteam/autobdd test framework;
2. serve as a template for setting up a new autobdd test project.

#### requirement:
1. docker,
2. docker-compose
3. git
4. vnc client/viewer

#### demo setup:
1. mkdir -p $HOME/Projects
2. git clone https://github.com/xyteam/autobdd-test.git $HOME/Projects/autobdd-test

#### test and report:
results are grouped by test suite under `test-results/`:

```
test-results/
├── e2e-test/
│   ├── single-runner-report/       # cucumber html - single-runner (test-1nit)
│   ├── parallel-runner-report/       # cucumber html - parallel runner (test-autobdd-libs)
│   └── auto-runner-report/    # cucumber html - auto-runner
├── cy-test/                  # cypress run.log + video/screenshot artifacts
├── js-test/                  # jest run.log
├── py3-test/                 # pytest run.log
└── k6-test/                  # k6 run.log
```

##### open result files per suite
each suite produces a result file to inspect:

| suite | result file | how to view |
|-------|-------------|-------------|
| e2e-test | `e2e-test/auto-runner-report/index.html` | open in a browser (cucumber html report) |
| e2e-test | `e2e-test/parallel-runner-report/index.html` | open in a browser |
| e2e-test | `e2e-test/single-runner-report/index.html` | open in a browser |
| cy-test | `cy-test/run.log` (and `cy-test/*.mp4` video) | open log in a text editor |
| js-test | `js-test/run.log` | open in a text editor |
| py3-test | `py3-test/run.log` | open in a text editor |
| k6-test | `k6-test/run.log` | open in a text editor |

the cucumber html reports are self-contained single pages - open the `index.html`
directly in a browser; the `run.log` files are plain text.

##### e2e test
```
docker-compose run --rm autobdd-test-run "make e2e-test"
```

#### performance test
###### k6 performance test
```
docker-compose run --rm autobdd-test-run "make k6-test"
```
#### unit test
###### jest
```
docker-compose run --rm autobdd-test-run "make js-test"
```
###### cypress
```
docker-compose run --rm autobdd-test-run "make cy-test"
```
###### python3
```
docker-compose run --rm autobdd-test-run "make py3-test"
```
#### test all in one-shot
```
docker-compose run --rm autobdd-test-run "xvfb-runner.sh make test-all"
```

#### test development env

###### start dev container:
```
docker-compose up -d autobdd-test-dev
```
###### ssh access to dev container:
```
ssh -o StrictHostKeyChecking=no localhost -p 2224
default password is *ubuntu*
```
###### vnc viewer access to dev container:
launch remmina (or another vnc client):
```
remmina -c vnc://localhost:5924
```
(default password is *ubuntu*)
###### run single test from ssh shell:
```
cd e2e-test/test-something
single-runner.sh features/test_image.feature
single-runner.sh features/test_ocr.feature:7
```
Observe browser GUI from vnc viewer

