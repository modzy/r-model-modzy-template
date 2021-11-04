# R gRPC Model Template

![Modzy Logo](https://www.modzy.com/wp-content/uploads/2020/06/MODZY-RGB-POS.png)

<div align="center">

**This is a gRPC + HTTP/2 template that can be used to easily produce machine learning models written using R that can be deployed to the Modzy platform.**

![GitHub contributors](https://img.shields.io/github/contributors/modzy/public-repo-starter-template)
![GitHub last commit](https://img.shields.io/github/last-commit/modzy/public-repo-starter-template)
![GitHub Release Date](https://img.shields.io/github/issues-raw/modzy/public-repo-starter-template)

[Python gRPC Model Template](https://github.com/modzy/grpc-model-template) | [Python HTTP Model Template](https://github.com/modzy/python-model-template)
</div>

### Template Overview

Description of top-level contents
```
.
├── Dockerfile           # Used to run and release your model in a docker container
├── README.md            # Documentation for the template repository
├── asset_bundle         # Metadata for each version of your model used to package and release your model
├── grpc_model           # Library for the gRPC server (leverages rpy2 package to connect model R script to Python gRPC server)
├── model_lib            # Library for your R machine learning model and its Modzy Wrapper
├── protos               # Protocol buffer used by the gRPC server and client
├── requirements.txt     # Example of a Python Requirements file with minimum dependencies
└── scripts              # Location to store shell scripts
```

## Usage

### Environment Set Up
To use this template and test your model, you will need the following dependencies installed within your environment:
* python>=3.6
* R>=4.1.1
* radian>=0.5.12
* Docker>=20.10.7
* Your preferred virtual environment tool (e.g., venv, conda) 

### Requirements for Developing your own model from the template

1. **Migrate your existing Model Library or Develop a Model Library from Scratch**
   
    Use `model_lib/src` to store your model library and use `model_lib/tests` in order to store its associated test 
    suite. Your existing model library can be directly imported into this repository with any structure, however, you
    are required to expose functionality to instantiate and perform inference using your model at a minimum. For
    developers, it is recommended that the complete training code as well as the model architecture be included and 
    documented within your model library in order to ensure full reproducibility and traceability.
    
2. **Integrate your Model into the Modzy Model Wrapper Class**
   
    Navigate to the `model_lib/src/model.R` file within the repository, which contains the Modzy Model Wrapper Class, `r_model_class`.
    This wrapper class is an R S4 class implementation of the `ExampleModel` python class in the [grpc Python Model Template](https://github.com/modzy/grpc-model-template/blob/master/model_lib/src/model.py)
    Proceed to fill out `handle_single_input()` by following the instructions provided in the 
    comments for this module.
   
    Optional: 
     - Complete the `handle_input_batch()` method  in order to enable custom batch processing for your model.
     - Refactor the `r_model_class` class name in order to give your model a custom name. You will need to do so [here](https://github.com/modzy/r-model-modzy-template/blob/master/grpc_model/src/model_server.py#L169).

3. **Provide model Metadata**

    Create a new version of your model using semantic versioning, `x.x.x`, and create a new directory for this version
    under `asset bundle`. Fill out a `model.yaml` and `docker_metadata.yaml` file under `asset_bundle/x.x.x/` according
    to the proper specification and then update the `__VERSION__ = x.x.x` variable located in `grpc_model/__init__.py`
    prior to performing the release for your new version of the model. Also, you must update the following line in the
    `Dockerfile`: `COPY asset_bundle/x.x.x ./asset_bundle/x.x.x/`
    
4. **Generate functional test cases**

    Generate functional test case cases for your model under `asset_bundle/<version>/test_cases`. For each test
    case, create a directory with a unique name that describes your test, and contains a complete set of input files,
    as specified in your `model.yaml` file as well as all the corresponding output files with the expected results for
    running the model on those input files.
    
    
### Model Testing and Deployment

This section expands on the minimum requirements to leverage the model template to develop your own Modzy compatible
model and provides users with a recommended procedure for phased testing in order to provide a pathway to deployment.    

1. **Testing model from a Custom Client in a Virtual Environment**

    If you would like to run example inputs against your model for inference, you can now set up a gRPC server hosting
    your model, and use a gRPC client to send inputs. You can write your own gRPC client, or use the example Python
    gRPC client provided in `grpc_model/src/model_client.py`. In order to set the client up to run for your specific
    model, all that you need to do is follow the documentation provided in this module to update the `__main__` section
    to load and use your specific input files.

    When your custom client is ready to run, create a virtual environment and install the required python dependencies.

    `python -m venv my-virtual-env`

    Activate your environment and use pip to install required python packages from `requirements.txt` file.

    _Linux and MacOS_
    ```
    source my-virtual-env/bin/activate
    pip install -r requirements.txt
    ```

    _Windows_
    ```
    my-virtual-env\Scripts\activate.bat
    pip install -r requirements.txt
    ```

    Once this is complete you can perform the two following commands in sequence in separate terminals in order to set
    up a local grpc server that is hosting your model and then use the client to perform some example inferences.

    ```
    python -m grpc_model.src.model_server
    python -m grpc_model.src.model_client
    ```

2. **Testing model from a Custom Client inside Docker Container**

    Next, you can perform the same sequence of tests that were performed in step 1, while hosting the gRPC server for
    your model inside a docker container to ensure that you set up the Dockerfile correctly.

    To start your model inside a container
    ```
    docker build --rm -t example-r-model .
    docker run --rm --name r-model-template -it -p 45000:45000 example-r-model
    ```

    Then, test the containerized server from a local client (same as second test command in step 1).

    `python -m grpc_model.src.model_client`


## Contributing

We are happy to receive contributions from all of our users. Check out our [contributing file](https://github.com/modzy/r-model-modzy-template/blob/master/CONTRIBUTING.md) to learn more.

## Code of conduct

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](https://github.com/modzy/r-model-modzy-template/blob/master/CODE_OF_CONDUCT.md)
