################################################################################
#
# containerd
#
################################################################################
CONTAINERD_BIN_VERSION = v2.1.3
CONTAINERD_BIN_SITE = https://github.com/containerd/containerd/releases/download/$(CONTAINERD_BIN_VERSION)
CONTAINERD_BIN_SOURCE = containerd-$(CONTAINERD_BIN_VERSION:v%=%)-linux-amd64.tar.gz

define CONTAINERD_BIN_USERS
	- -1 containerd-admin -1 - - - - -
	- -1 containerd       -1 - - - - -
endef

define CONTAINERD_BIN_INSTALL_TARGET_CMDS
	$(INSTALL) -Dm755 \
		$(@D)/containerd \
		$(TARGET_DIR)/bin
	$(INSTALL) -Dm755 \
		$(@D)/containerd-shim-runc-v2 \
		$(TARGET_DIR)/usr/bin
	$(INSTALL) -Dm755 \
		$(@D)/ctr \
		$(TARGET_DIR)/usr/bin
	$(INSTALL) -Dm644 \
		$(CONTAINERD_BIN_PKGDIR)/config.toml \
		$(TARGET_DIR)/etc/containerd/config.toml
	$(INSTALL) -Dm644 \
		$(CONTAINERD_BIN_PKGDIR)/containerd_docker_io_hosts.toml \
		$(TARGET_DIR)/etc/containerd/certs.d/docker.io/hosts.toml
endef

define CONTAINERD_BIN_INSTALL_INIT_SYSTEMD
	$(INSTALL) -Dm644 \
		$(CONTAINERD_BIN_PKGDIR)/containerd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/containerd.service
	$(INSTALL) -Dm644 \
		$(CONTAINERD_BIN_PKGDIR)/50-minikube.preset \
		$(TARGET_DIR)/usr/lib/systemd/system-preset/50-minikube.preset
endef

$(eval $(generic-package))
