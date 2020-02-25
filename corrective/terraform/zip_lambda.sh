#!/bin/bash

cd ../lambda/function_code
zip -r ../../terraform/lambda.zip *
cd ../../terraform
