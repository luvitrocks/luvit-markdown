PREFIX?=/usr/local
LIBDIR?=${PREFIX}/lib/luvit

install:
	@mkdir -p ${LIBDIR}
	@if [ ! -w ${LIBDIR} ]; then \
		echo "Target directory \"${LIBDIR}\" is not writable."; \
		echo "Try installing with a suitable user."; \
		exit 1; \
	fi
	@cp src/markdown.lua ${LIBDIR}/markdown.lua;
	@echo "Installation completed!"

uninstall:
	@if [ -f ${LIBDIR}/markdown.lua ] && [ ! -w ${LIBDIR}/markdown.lua ]; then \
		echo "Not allowed to delete \"${LIBDIR}/markdown.lua\"."; \
		echo "Try uninstalling with a suitable user."; \
		exit 1; \
	fi
	@rm -f ${LIBDIR}/markdown.lua
	@echo "Uninstallation completed!"

test:
	@luvit src/test.lua
	@echo "Tests completed!"