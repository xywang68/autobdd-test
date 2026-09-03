testSectionBegin="=======\nTest\n-------"
testSectionEnd="----------\nDone Test\n=========="

.PHONY: docker-run test-all test clean e2e-test cy-test js-test py3-test k6-test

# export dynamic env for docker-compose (not shell-substitutable in .env)
export USER ?= $(shell whoami)
export HOSTOS ?= $(shell uname -s)
export USERID ?= $(shell id -u)
export GROUPID ?= $(shell id -g)
export PASSWORD ?= ubuntu

docker-run:
	@echo make $@
	docker-compose run --rm autobdd-test-run "xvfb-runner.sh make ${jobs}"
docker-run-bash:
	@echo make $@
	docker-compose run --rm autobdd-test-run "/bin/bash"
docker-up:
	@echo make $@
	docker-compose up -d autobdd-test-dev
docker-logs:
	@echo make $@
	docker-compose logs autobdd-test-dev
docker-logs-f:
	@echo make $@
	docker-compose logs -f autobdd-test-dev
docker-down:
	@echo make $@
	docker-compose down
docker-ssh:
	ssh $$USER@localhost -p 2224 || exit $?

clean:
	@echo make $@
	@echo "cleaning autorunner-report folder...";
	rm -rf test-results/*;
	find . -type d -name "__pycache__" -o -name ".pytest_cache" | xargs rm -rf;
	find . -type f -name "*.pyc" | xargs rm -f;
	find e2e-test -type d -name logs | xargs rm -rf;
	find e2e-test -type d -name test-results -o -name arunner-report -o -name prunner-report -o -name autorunner-report | xargs rm -rf;
	find e2e-test -type f -name "test-*.json" | xargs rm -f;
	find e2e-test -type f -name "Passed_*.???" -o -name "Failed_*.???" -o -name "Recording_*.???" | xargs rm -f;

e2e-arunner:
	@echo make $@
	@echo ${testSectionBegin};
	@echo "running cucumber test with arunner.sh (single runner)...";
	cd e2e-test/test-1nit && SCREENSHOT=3 MOVIE=1 REPORTDIR=../../test-results/e2e-test/arunner-report arunner.sh -x || exit $$?;
	@echo ${testSectionEnd}

e2e-prunner:
	@echo make $@
	@echo ${testSectionBegin};
	@echo "running cucumber test with prunner.sh (parllel runner)...";
	cd e2e-test/test-autobdd-libs && SCREENSHOT=3 MOVIE=1 REPORTDIR=../../test-results/e2e-test/prunner-report prunner.sh || exit $$?;
	@echo ${testSectionEnd}

e2e-autorunner:
	@echo make $@
	@echo ${testSectionBegin};
	@echo "running cucumber test with autorunner (parallel runner with cucumber report)...";
	autorunner.py --project autobdd-test --reportpath e2e-test/autorunner-report --movie 1 -- --cucumberOpts.tags='not @Init and not @Report' || exit $$?;
	find test-results/e2e-test/autorunner-report -type f -name "*.run" | xargs cat || exit $$?;
	@echo ${testSectionEnd}

e2e-autoreport:
	@echo make $@
	@echo ${testSectionBegin};
	@echo "checking cucumber report...";
	cd e2e-test/test-autobdd-reports && REPORTDIR=../../test-results/e2e-test/autoreport prunner.sh || exit $$?;
	@echo ${testSectionEnd}

e2e-test: e2e-arunner e2e-prunner e2e-autorunner e2e-autoreport
	@echo make $@

js-test:
	@echo make $@
	@echo ${testSectionBegin};
	@echo "running jest unit test...";
	mkdir -p test-results/js-test; \
	cd js-test && npm install && \
	node_modules/.bin/jest --verbose . > ../test-results/js-test/run.log 2>&1; \
	exit $$?;
	@echo ${testSectionEnd}

py3-test:
	@echo make $@
	@echo ${testSectionBegin};
	@echo "running python3 unit test...";
	mkdir -p test-results/py3-test; \
	pip3 install -r py-test/requirement3.txt && \
	python3 -m pytest -r A py-test > test-results/py3-test/run.log 2>&1; \
	exit $$?;
	@echo ${testSectionEnd}

cal-app-start:
	@echo make $@
	@echo "starting up cal-app...";
	cd cal-app && npm install && npm start

cal-app-stop:
	@echo make $@
	@echo "stopping cal-app...";
	cd cal-app && npm stop

cy-test: cal-app-start
	@echo make $@
	@echo ${testSectionBegin};
	@echo "running cypress test...";
	mkdir -p test-results/cy-test; \
	cd cal-app && \
	xvfb-runner.sh bash -c "node_modules/.bin/cypress install && node_modules/.bin/cypress run" > ../test-results/cy-test/run.log 2>&1; \
	st=$$?; \
	[ -d cypress/videos ] && cp -r cypress/videos/* ../test-results/cy-test/ 2>/dev/null; \
	[ -d cypress/screenshots ] && cp -r cypress/screenshots/* ../test-results/cy-test/ 2>/dev/null; \
	exit $$st;
	@echo ${testSectionEnd}

k6-test:
	@echo make $@
	@echo ${testSectionBegin};
	@echo "running k6 performance test...";
	mkdir -p test-results/k6-test; \
	cd k6-test && for f in $$(find . -type f -name "*-test.js"); do k6 run "$$f"; done > ../test-results/k6-test/run.log 2>&1; \
	exit $$?;
	@echo ${testSectionEnd}

test-all: clean e2e-test cy-test js-test py3-test k6-test
	@echo make $@
