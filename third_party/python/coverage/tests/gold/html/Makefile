# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

help:
	@echo "Available targets:"
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

complete: 	## Copy support files into directories so the HTML can be viewed properly.
	@for sub in *; do \
		if [[ -f $$sub/index.html ]]; then \
			echo Copying into $$sub ; \
			cp -n support/* $$sub ; \
		fi ; \
	done ; \
	true	# because the for loop exits with 1 for some reason.

clean:		## Remove the effects of this Makefile.
	git clean -fq .

update-gold:	## Copy output files from latest tests to gold files.
	@for sub in $$TMPDIR/coverage_test/*HtmlGoldTests*/out; do \
		rsync --verbose --existing --recursive $$sub/ . ; \
	done ; \
	true

update-support:	## Copy latest support files here for posterity.
	cp ../../../coverage/htmlfiles/*.{css,js,png} support
