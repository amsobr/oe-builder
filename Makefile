VERSION=0.1
BUILD_DIR=build
LAUNCHER_SCRIPT=$(BUILD_DIR)/oe-builder-$(VERSION)
REDIST_SCRIPT=$(BUILD_DIR)/oe-builder
DOCKER_PKG=$(BUILD_DIR)/docker-$(VERSION)
DOCKER_PKG_TARBALL=$(DOCKER_PKG).tar.xz

.ALL: $(REDIST_SCRIPT)

.PHONY: clean

$(REDIST_SCRIPT): $(LAUNCHER_SCRIPT) $(DOCKER_PKG_TARBALL)
	cat $(LAUNCHER_SCRIPT) $(DOCKER_PKG_TARBALL) > $(REDIST_SCRIPT)
	chmod +x $(REDIST_SCRIPT)
	echo "Redistributable SFX script created at $(REDIST_SCRIPT)"

$(LAUNCHER_SCRIPT): Makefile build.sh.in oe-builder.in
	test -d $(BUILD_DIR) || mkdir -p $(BUILD_DIR)
	sed -e "s/%%VERSION%%/$(VERSION)/g" \
		-e "s/%%ALL_RELEASES%%/$$(cat build.sh.in | grep '^ALL_RELEASES=' | sed 's/ALL_RELEASES=//'g)/g" \
		oe-builder.in > $(LAUNCHER_SCRIPT)

$(DOCKER_PKG_TARBALL): bashrc.sh.in build.sh.in Dockerfile.in entry-point.sh Makefile
	test -d $(DOCKER_PKG) || mkdir -p $(DOCKER_PKG)
	sed -e "s/%%VERSION%%/$(VERSION)/g" \
		bashrc.sh.in > $(DOCKER_PKG)/bashrc.sh.in
	sed -e "s/%%VERSION%%/$(VERSION)/g" \
		build.sh.in > $(DOCKER_PKG)/build.sh
	chmod +x $(DOCKER_PKG)/build.sh
	cp Dockerfile.in $(DOCKER_PKG)
	cp entry-point.sh $(DOCKER_PKG)
	tar vcJf $(DOCKER_PKG_TARBALL) -C $(DOCKER_PKG) .

clean:
	rm -rf $(BUILD_DIR)

