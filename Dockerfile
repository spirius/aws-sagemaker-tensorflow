FROM 520713654638.dkr.ecr.eu-central-1.amazonaws.com/sagemaker-tensorflow-scriptmode:1.12.0-cpu-py3

RUN apt-get update -y && apt-get install -y openjdk-8-jdk curl pkg-config zip g++ zlib1g-dev unzip git

# Installing Bazel
RUN curl -OfL https://github.com/bazelbuild/bazel/releases/download/0.17.2/bazel-0.17.2-installer-linux-x86_64.sh
RUN chmod +x bazel-0.17.2-installer-linux-x86_64.sh
RUN ./bazel-0.17.2-installer-linux-x86_64.sh

# Tensorflow
RUN git clone -b v1.12.0 --depth 1 https://github.com/tensorflow/tensorflow.git

WORKDIR /tensorflow

RUN pip3 install pip six numpy wheel setuptools mock
RUN pip3 install keras_applications==1.0.6 --no-deps
RUN pip3 install keras_preprocessing==1.0.5 --no-deps

RUN ./configure
RUN bazel build --copt=-mno-fma --copt=-mavx --copt=-mavx2 --copt=-msse4.1 --copt=-msse4.2 //tensorflow/tools/pip_package:build_pip_package

RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

FROM 520713654638.dkr.ecr.eu-central-1.amazonaws.com/sagemaker-tensorflow-scriptmode:1.12.0-cpu-py3

COPY --from=0 /tmp/tensorflow_pkg /tmp/tensorflow_pkg
RUN pip install --force-reinstall /tmp/tensorflow_pkg/tensorflow-*.whl && rm -rf /tmp/tensorflow_pkg
