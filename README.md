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
│   ├── arunner-report/       # cucumber html - single-runner (test-1nit)
│   ├── prunner-report/       # cucumber html - parallel runner (test-autobdd-libs)
│   ├── autorunner-report/    # cucumber html - autorunner
│   └── autoreport/           # check_build_report validation output
├── cy-test/                  # cypress run.log + video/screenshot artifacts
├── js-test/                  # jest run.log
├── py3-test/                 # pytest run.log
└── k6-test/                  # k6 run.log
```

##### e2e test
```
docker-compose run --rm autobdd-test-run "make e2e-autorunner"
```
##### review e2e test report
use browser to open searchable cucumber report

test-results/e2e-test/autorunner-report/index.html

or

lauch a http server:
```
cd test-results
python -m http.server
```
then open a browser to http://host-ip:8000
to review the report

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
or
ssh -o StrictHostKeyChecking=no $USER@ip.add.re.ss -p 2224
default password is *ubuntu*
```
###### vnc viewer access to dev container:
```
vnc://ip.add.re.ss:5904
```
###### run single test from ssh shell:
```
cd e2e-test/test-something
arunner.sh features/test_image.feature
arunner.sh features/test_ocr.feature:7
```
Observe browser GUI from vnc viewer

#### set up IDE and play with autobdd-test code:
1. install vscode

2. in vscode install

   2.1 remote development extension
   
   2.2 gherkin/cucumber full support
   
3. in vscode open ssh target on port 2224

4. open folder $HOME/Projects/AutoBDD

5. go to test-projects to find your test project

6. start developing and testing

   6.1 test code saved inside autobdd-test or BDD_PROJECT will persist inside and outside of the container

   6.2 other code will not.

#### set up new project
1. stop autobdd-test docker containers

   1.1 docker-compose down
   
   1.2 docker container prune -f

2. reset git

   2.1 rm -rf autobdd-test/.git
   
   2.2 git init
   
3. rename autobdd-test to new-project-name

   3.1 edit .env, change BDD_PROJECT=autobdd-test to BDD_PROJECT=new-project-name
   
   3.2 edit docker-compose.yml, update service name autobdd-test-run and autobdd-test-dev to new-project-name-run and new-project-name-dev respectively
   
   3.3 optionally, to support multiple test projects, update port set 2224, 5904 and 8004 to 2226, 5906 and 8006 or 2228, 5908 and 8008, etc
   
4. test new project

   4.1 docker-compose run --rm new-project-name-run "make xvfb-ruinner.sh test-all"
   
   4.2 docker-compose up -d new-project-name-dev
