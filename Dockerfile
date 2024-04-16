# https://docs.aws.amazon.com/lambda/latest/dg/python-image.html#python-image-instructions
FROM public.ecr.aws/lambda/python:3.11
COPY lambda_function.py ${LAMBDA_TASK_ROOT}
CMD [ "lambda_function.handler" ]
