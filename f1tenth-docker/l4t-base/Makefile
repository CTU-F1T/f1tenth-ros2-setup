# Copyright (c) 2020-2022, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DOC     = /usr/share/doc/cuda
VAR     = /var/cuda

RELEASE = r32.7
TAG     = r32.7.2-u22
CUDA    = 10.2
L4T_CUDA_REGISTRY   = "ctu-f1t/l4t-cuda"
L4T_BASE_REGISTRY   = "ctu-f1t/l4t-base"

include $(CURDIR)/common.mk

image_r32:
	mkdir -p ${CURDIR}/dst
	docker build $(DOCKER_BINFMT_MISC) -t $(L4T_CUDA_REGISTRY):$(TAG) \
		--build-arg "RELEASE=$(RELEASE)" --build-arg "CUDA=$(CUDA)" \
		-f ./Dockerfile.cuda ./
	docker run -t $(DOCKER_BINFMT_MISC) -v $(CURDIR)/dst:/dst $(L4T_CUDA_REGISTRY):$(TAG) sh -c 'cp -r /usr/local/cuda/* /dst'
	docker build $(DOCKER_BINFMT_MISC) -t $(L4T_BASE_REGISTRY):$(TAG) \
		--build-arg "RELEASE=$(RELEASE)" --build-arg "CUDA=$(CUDA)" \
		-f ./Dockerfile.l4t_r32 .

	# docker rm $(docker ps -a | grep ${L4T_CUDA_REGISTRY}:${TAG} | head -n1 | awk '{print $1;}')
	# docker rmi $(docker images | grep ${L4T_CUDA_REGISTRY}:${TAG} | head -n1 | awk '{print $3;}')

# -v $(CURDIR)/dst:/dst 