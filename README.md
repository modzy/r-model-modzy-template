# R gRPC Model Template

![Modzy Logo](https://www.modzy.com/wp-content/uploads/2020/06/MODZY-RGB-POS.png)

<div align="center">

**This is a gRPC + HTTP/2 template that can be used to easily produce machine learning models written using R that can be deployed to the Modzy platform.**

![GitHub contributors](https://img.shields.io/github/contributors/modzy/public-repo-starter-template)
![GitHub last commit](https://img.shields.io/github/last-commit/modzy/public-repo-starter-template)
![GitHub Release Date](https://img.shields.io/github/issues-raw/modzy/public-repo-starter-template)

[Python gRPC Model Template](https://github.com/modzy/grpc-model-template) | Python HTTP Model Template(https://github.com/modzy/python-model-template)
</div>

### Template Overview

Description of top-level contents
```
.
├── Dockerfile           # Used to run and release your model in a docker container
├── README.md            # Documentation for the template repository
├── asset_bundle         # Metadata for each version of your model used to package and release your model
├── grpc_model           # Library for the gRPC server (leverages rpy2 package to connect model R script to Python gRPC server
├── model_lib            # Library for your R machine learning model and its Modzy Wrapper
├── protos               # Protocol buffer used by the gRPC server and client
├── requirements.txt     # Example of a Python Requirements file with minimum dependencies
└── scripts              # Location to store shell scripts
```

## Usage

## Table of contents

- [Folders or files within your repository](<link to folder or file>)

## Contributing

We are happy to receive contributions from all of our users. Check out our [contributing file](https://github.com/modzy/public-repo-starter-template/blob/master/CONTRIBUTING.adoc) to learn more.

## Code of conduct

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](https://github.com/modzy/public-repo-starter-template/blob/master/CODE_OF_CONDUCT.md)
