TEST_DIR       = test
TEST_DIFF      = ${TEST_DIR}/test.diff
VALID_TEST_OUT = ${TEST_DIR}/plan.txt
TF_OPTS        = -no-color
TF             = tofu -chdir=${TEST_DIR}

all:
	@echo There is only a '"test"' target

test: clean ${TEST_DIR}/test.out

${TEST_DIR}/test.out:
	@echo installing...
	${TF} init ${TF_OPTS}
	@echo running test...
	${TF} plan ${TF_OPTS} > $@
	@echo verifying result...
	@if diff -ubw ${VALID_TEST_OUT} $@ >${TEST_DIFF}; then \
		echo ok; rm -f ${TEST_DIFF}; \
	else \
		echo FAILED -- see ${TEST_DIFF}; \
	fi

clean:
	@$(RM) -r .terraform
	@$(RM) ${TEST_DIR}/test.out ${TEST_DIFF}
