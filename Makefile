include $(TOPDIR)/rules.mk

PKG_NAME:=pic32prog
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/pic32prog-$(PKG_VERSION)
PKG_SOURCE:=master.zip
PKG_SOURCE_URL:=https://github.com/sergev/pic32prog/archive/master.zip
PKG_HASH:=9b7dc52656f5cbec846a7ba3299f73bd
PKG_CAT:=unzip

include $(INCLUDE_DIR)/package.mk

define Package/pic32prog
  SECTION:=base
  CATEGORY:=Development
  TITLE:=Utility for loading data into flash of PIC32 microcontrollers
  URL:=https://github.com/sergev/pic32prog
endef

define Package/pic32prog/description
  Pic32prog is a utility forloading data into a flash memory of
  Microchip PIC32 microcontrollers
endef

define Build/Configure
  $(call Build/Configure/Default,--with-linux-headers=$(LINUX_DIR))
endef

define Package/pic32prog/install
        $(INSTALL_DIR) $(1)/usr/bin
        $(INSTALL_BIN) $(1)/usr/bin/
endef

$(eval $(call BuildPackage,pic32prog))
