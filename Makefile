
build:
	@make -C hbase
	@make -C kafka


# Makefile variables
RUNNING_CONTAINERS=$(shell docker ps -q)
STOPPED_CONTAINERS=$(shell docker ps -q -a)
UNTAGGED_IMAGES=$(shell docker images -q -f dangling=true)

# delete containers and untagged images
remove rm del delete: stop
ifneq ($(STOPPED_CONTAINERS),)
	@printf "\n>>> Deleting stopped containers\n" && docker rm $(STOPPED_CONTAINERS)
endif
ifneq ($(UNTAGGED_IMAGES),)
	@printf "\n>>> Deleting untagged images\n\n" && docker rmi $(UNTAGGED_IMAGES)
endif

# kill running containers
stop kill:
ifneq ($(RUNNING_CONTAINERS),)
	@printf "\n>>> Killing all running containers\n" && docker kill $(RUNNING_CONTAINERS)
endif
