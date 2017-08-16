# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

include $(MOZILLA_DIR)/toolkit/mozapps/installer/package-name.mk
include $(MOZILLA_DIR)/toolkit/mozapps/installer/upload-files.mk

# This is how we create the binary packages we release to the public.

# browser/locales/Makefile uses this makefile for its variable defs, but
# doesn't want the libs:: rule.
ifndef PACKAGER_NO_LIBS
libs:: make-package
endif

installer-stage: prepare-package
ifndef MOZ_PKG_MANIFEST
	$(error MOZ_PKG_MANIFEST unspecified!)
endif
	@rm -rf $(DEPTH)/installer-stage $(DIST)/xpt
	@echo 'Staging installer files...'
	@$(NSINSTALL) -D $(DEPTH)/installer-stage/core
	@cp -av $(DIST)/$(MOZ_PKG_DIR)$(_BINPATH)/. $(DEPTH)/installer-stage/core
	@(cd $(DEPTH)/installer-stage/core && $(CREATE_PRECOMPLETE_CMD))
ifdef MOZ_SIGN_PREPARED_PACKAGE_CMD
# The && true is necessary to make sure Pymake spins a shell
	$(MOZ_SIGN_PREPARED_PACKAGE_CMD) $(DEPTH)/installer-stage && true
endif

ifeq (gonk,$(MOZ_WIDGET_TOOLKIT))
ELF_HACK_FLAGS = --fill
endif
export USE_ELF_HACK ELF_HACK_FLAGS

# Override the value of OMNIJAR_NAME from config.status with the value
# set earlier in this file.

stage-package: $(MOZ_PKG_MANIFEST) $(MOZ_PKG_MANIFEST_DEPS)
	OMNIJAR_NAME=$(OMNIJAR_NAME) \
	NO_PKG_FILES="$(NO_PKG_FILES)" \
	$(PYTHON) $(MOZILLA_DIR)/toolkit/mozapps/installer/packager.py $(DEFINES) $(ACDEFINES) \
		--format $(MOZ_PACKAGER_FORMAT) \
		$(addprefix --removals ,$(MOZ_PKG_REMOVALS)) \
		$(if $(filter-out 0,$(MOZ_PKG_FATAL_WARNINGS)),,--ignore-errors) \
		$(if $(MOZ_PACKAGER_MINIFY),--minify) \
		$(if $(MOZ_PACKAGER_MINIFY_JS),--minify-js \
		  $(addprefix --js-binary ,$(JS_BINARY)) \
		) \
		$(if $(JARLOG_DIR),$(addprefix --jarlog ,$(wildcard $(JARLOG_FILE_AB_CD)))) \
		$(if $(OPTIMIZEJARS),--optimizejars) \
		$(if $(DISABLE_JAR_COMPRESSION),--disable-compression) \
		$(MOZ_PKG_MANIFEST) $(DIST) $(DIST)/$(MOZ_PKG_DIR)$(if $(MOZ_PKG_MANIFEST),,$(_BINPATH)) \
		$(if $(filter omni,$(MOZ_PACKAGER_FORMAT)),$(if $(NON_OMNIJAR_FILES),--non-resource $(NON_OMNIJAR_FILES)))
	$(PYTHON) $(MOZILLA_DIR)/toolkit/mozapps/installer/find-dupes.py $(DEFINES) $(ACDEFINES) $(MOZ_PKG_DUPEFLAGS) $(DIST)/$(MOZ_PKG_DIR)
ifndef MOZ_THUNDERBIRD
	# Package mozharness
	$(call py_action,test_archive, \
		mozharness \
		$(ABS_DIST)/$(PKG_PATH)$(MOZHARNESS_PACKAGE))
endif # MOZ_THUNDERBIRD
ifdef MOZ_PACKAGE_JSSHELL
	# Package JavaScript Shell
	@echo 'Packaging JavaScript Shell...'
	$(RM) $(PKG_JSSHELL)
	$(MAKE_JSSHELL)
endif # MOZ_PACKAGE_JSSHELL
ifdef MOZ_ARTIFACT_BUILD_SYMBOLS
	@echo 'Packaging existing crashreporter symbols from artifact build...'
	$(NSINSTALL) -D $(DIST)/$(PKG_PATH)
	cd $(DIST)/crashreporter-symbols && \
          zip -r5D '../$(PKG_PATH)$(SYMBOL_ARCHIVE_BASENAME).zip' . -i '*.sym' -i '*.txt'
endif # MOZ_ARTIFACT_BUILD_SYMBOLS
ifdef MOZ_CODE_COVERAGE
	# Package code coverage gcno tree
	@echo 'Packaging code coverage data...'
	$(RM) $(CODE_COVERAGE_ARCHIVE_BASENAME).zip
	$(PYTHON) -mmozbuild.codecoverage.packager \
		--output-file='$(DIST)/$(PKG_PATH)$(CODE_COVERAGE_ARCHIVE_BASENAME).zip'
endif
ifeq (Darwin, $(OS_ARCH))
ifdef MOZ_ASAN
	@echo "Rewriting ASan runtime dylib paths for all binaries in $(DIST)/$(MOZ_PKG_DIR)$(_BINPATH) ..."
	$(PYTHON) $(MOZILLA_DIR)/build/unix/rewrite_asan_dylib.py $(DIST)/$(MOZ_PKG_DIR)$(_BINPATH)
endif # MOZ_ASAN
endif # Darwin
ifdef MOZ_STYLO
ifndef MOZ_ARTIFACT_BUILDS
	@echo 'Packing stylo binding files...'
	cd '$(DIST)/rust_bindings/style' && \
		zip -r5D '$(ABS_DIST)/$(PKG_PATH)$(STYLO_BINDINGS_PACKAGE)' .
endif # MOZ_ARTIFACT_BUILDS
endif # MOZ_STYLO

prepare-package: stage-package

make-package-internal: prepare-package make-sourcestamp-file make-buildinfo-file make-mozinfo-file
	@echo 'Compressing...'
	cd $(DIST) && $(MAKE_PACKAGE)

make-package: FORCE
	$(MAKE) make-package-internal
	$(TOUCH) $@

GARBAGE += make-package

make-sourcestamp-file::
	$(NSINSTALL) -D $(DIST)/$(PKG_PATH)
	@echo '$(BUILDID)' > $(MOZ_SOURCESTAMP_FILE)
ifdef MOZ_INCLUDE_SOURCE_INFO
	@awk '$$2 == "MOZ_SOURCE_URL" {print $$3}' $(DEPTH)/source-repo.h >> $(MOZ_SOURCESTAMP_FILE)
endif

.PHONY: make-buildinfo-file
make-buildinfo-file:
	$(PYTHON) $(MOZILLA_DIR)/toolkit/mozapps/installer/informulate.py \
		$(MOZ_BUILDINFO_FILE) \
		BUILDID=$(BUILDID) \
		$(addprefix MOZ_SOURCE_REPO=,MOZ_SOURCE_REPO=$(shell awk '$$2 == "MOZ_SOURCE_REPO" {print $$3}' $(DEPTH)/source-repo.h)) \
		MOZ_SOURCE_STAMP=$(shell awk '$$2 == "MOZ_SOURCE_STAMP" {print $$3}' $(DEPTH)/source-repo.h) \
		MOZ_PKG_PLATFORM=$(MOZ_PKG_PLATFORM)
	echo "buildID=$(BUILDID)" > $(MOZ_BUILDID_INFO_TXT_FILE)

.PHONY: make-mozinfo-file
make-mozinfo-file:
	cp $(DEPTH)/mozinfo.json $(MOZ_MOZINFO_FILE)

# The install target will install the application to prefix/lib/appname-version
install:: prepare-package
ifeq ($(OS_ARCH),WINNT)
	$(error "make install" is not supported on this platform. Use "make package" instead.)
endif
ifeq (bundle,$(MOZ_FS_LAYOUT))
	$(error "make install" is not supported on this platform. Use "make package" instead.)
endif
	$(NSINSTALL) -D $(DESTDIR)$(installdir)
	(cd $(DIST)/$(MOZ_PKG_DIR) && $(TAR) --exclude=precomplete $(TAR_CREATE_FLAGS) - .) | \
	  (cd $(DESTDIR)$(installdir) && tar -xf -)
	$(NSINSTALL) -D $(DESTDIR)$(bindir)
	$(RM) -f $(DESTDIR)$(bindir)/$(MOZ_APP_NAME)
	ln -s $(installdir)/$(MOZ_APP_NAME) $(DESTDIR)$(bindir)

checksum:
	mkdir -p `dirname $(CHECKSUM_FILE)`
	@$(PYTHON) $(MOZILLA_DIR)/build/checksums.py \
		-o $(CHECKSUM_FILE) \
		$(CHECKSUM_ALGORITHM_PARAM) \
		-s $(call QUOTED_WILDCARD,$(DIST)) \
		$(UPLOAD_FILES)
	@echo 'CHECKSUM FILE START'
	@cat $(CHECKSUM_FILE)
	@echo 'CHECKSUM FILE END'
	$(SIGN_CHECKSUM_CMD)


upload: checksum
	$(PYTHON) -u $(MOZILLA_DIR)/build/upload.py --base-path $(DIST) \
		--package '$(PACKAGE)' \
		--properties-file $(DIST)/mach_build_properties.json \
		$(UPLOAD_FILES) \
		$(CHECKSUM_FILES)

# source-package creates a source tarball from the files in MOZ_PKG_SRCDIR,
# which is either set to a clean checkout or defaults to $topsrcdir
source-package:
	@echo 'Generate the sourcestamp file'
	# Make sure to have repository information available and then generate the
	# sourcestamp file.
	$(MAKE) -C $(DEPTH) 'source-repo.h'
	$(MAKE) make-sourcestamp-file
	@echo 'Packaging source tarball...'
	# We want to include the sourcestamp file in the source tarball, so copy it
	# in the root source directory. This is useful to enable telemetry submissions
	# from builds made from the source package with the correct revision information.
	# Don't bother removing it as this is only used by automation.
	@cp $(MOZ_SOURCESTAMP_FILE) '$(MOZ_PKG_SRCDIR)/sourcestamp.txt'
	$(MKDIR) -p $(DIST)/$(PKG_SRCPACK_PATH)
	(cd $(MOZ_PKG_SRCDIR) && $(CREATE_SOURCE_TAR) - ./ ) | xz -9e > $(SOURCE_TAR)

hg-bundle:
	$(MKDIR) -p $(DIST)/$(PKG_SRCPACK_PATH)
	$(CREATE_HG_BUNDLE_CMD)

source-upload:
	$(MAKE) upload UPLOAD_FILES='$(SOURCE_UPLOAD_FILES)' CHECKSUM_FILE='$(SOURCE_CHECKSUM_FILE)'
