.PHONY: module.yaml

DG = /usr/bin/dg
DISTRO = fedora-26-x86_64
USERSPACE = fancy
DG_EXEC = ${DG} --distro ${DISTRO}.yaml --multispec dg-multispec.yaml --multispec-selector userspace=${USERSPACE}

module.yaml:
	${DG_EXEC} --template module.in --output module.yaml
