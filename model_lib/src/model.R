library(jsonlite)
# Add additional libraries and packages here as needed


# The required output structure for a successful inference run for a models is the following vector:

# output <- c(
#     "data" <- c(
#         "result" = result,
#         "explanation" = explanation,
#         "drift" = drift
#     )
# )

# The parent level `data` value is required and stores a nested vector which represents the output for a specific input. 
# The only top-level name within these dictionaries that is required is `result`, however, `explanation` and `drift` are 
# additional names that may be included if your particular model supports drift detection or explainability. All three of these names
# (`result`, `explanation`, and `drift`) are required to have a particular format in order to provide platform support.
# This format type must be specified in the model.yaml file for the version that you are releasing, and the structure for
# this format type must be followed. If no formats are specified, it is possible to define your own custom structure on a
# per-model basis.
# The required output structure for a failed inference run for a models is the following vector:

# errors <- c(
#     "error_message" = error_messsage
# )

# Here, all error information that you can extract can be loaded into a single string and returned. This could be a
# string with a structured error log, or a stack trace dumped to a string.

# Utility function to help format your output correctly before returning the results from your model S4 class  
get_success_json_structure <- function(inference, explanation, drift) {
    output_item_list <- c("data" = c("result" = inference, "explanation" = explanation, "drift" = drift)) # nolint
    return(output_item_list)
}

# Utility function to help format any errors accumulated during inference before returning the results from your model S4 class
get_failure_json_structure <- function(error_message) {
    error_list <- c("error_message" = error_message)
    return(error_list)
}

# define model class
r_model_class <- setRefClass(
    "MyModelClass",
    methods = list(
        initialize = function() {
            # This constructor should perform all initialization for your model. For example, all one-time tasks such as
            # loading your model weights into memory should be performed here.
            # This corresponds to the Status remote procedure call.
            print("Model loaded!")
        },
        preprocess = function(inputs) {
            # This is a sample data preprocessing method that can optionally be used if any data preprocessing is required 
            # during inference. If not relevant, the method can be deleted.
            processed_inputs <- paste(inputs, "plus preprocessing!", sep = " ")
            return(processed_inputs)
        },
        postprocess = function(raw_model_output) {
            # This is a sample data postprocessing method that can optionally be used if any results postprocessing is required 
            # during inference. If not relevant, the method can be deleted.
            postprocessed_outputs <- paste(
                raw_model_output,
                "plus postprocessing!",
                sep = " "
            )
            return(postprocessed_outputs)
        },
        handle_single_input = function(model_input, detect_drift, explain) {
            # This method corresponds to the Run remote procedure call for single inputs.

            # model_input will be an R list where the name will be the input filename as defind in model.yaml,
            # and the value will be decoded data that you are expected to process and pass through your model.

            # You are responsible for processing these files in a manner that is specific to your model, and producing
            # inference, drift, and explainability results where appropriate.            

            # The following walks through an example of how a user may implement a model inference flow

            # run inference on single input
            # define name(s) of inputs as defined in model.yaml file
            input_filename <- "input.txt"
            input_data <- model_input[[input_filename]]

            # send input data through custom preprocesing or postprocessing
            # methods, including your model for inference
            preprocessed_data <- preprocess(input_data)
            inference_result <- postprocess(preprocessed_data)

            # add custom explainability or drift outputs here as needed if
            # detect_drift or explain flags are set to TRUE
            if (!(explain)) {
                explanation_result <- "None"
            } else {
                # add conditional processing here as needed
                explanation_result <- "None" # change to custom explanations
            }
            if (!(detect_drift)) {
                drift_result <- "None"
            } else {
                # add conditional processing here as needed
                drift_result <- "None" # change to custom explanations
            }

            # combine inference result, drift result, and explanation result
            # into a single output object to be converted to json and returned
            # to user
            output <- get_success_json_structure(
                inference_result,
                explanation_result,
                drift_result
            )
            return(output)
        },
        handle_input_batch = function(model_input, detect_drift, explain) {
            # This is an optional method that will be attempted to be called when more than one inputs to the model
            # are ready to be processed. This enables a user to provide a more efficient means of handling inputs in batch
            # that takes advantage of specific properties of their model.
            # If you are not implementing custom batch processing, this method should return a not implemented error. If you are
            # implementing custom batch processing, then any unhandled exception will be interpreted as a fatal error that
            # will result in the entire batch failing. If you would like to allow individual elements of the batch to fail
            # without failing the entire batch, then you must handle the exception within this function, and ensure the JSON
            # structure for messages with an error has a top level "error" key with a detailed description of the error
            # message.
            # This corresponds to the Run remote procedure call for batch inputs.
            # c(
            #     "error" = "your error message here"
            # )
            #     
            
            simpleError("The batch method is not implemented")
        }
    )
)
