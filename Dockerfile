# syntax=docker/dockerfile:1
FROM docker.io/continuumio/miniconda3:latest

WORKDIR /

COPY ./src/requirements.txt /flow/requirements.txt

# gcc is for build psutil in MacOS
RUN apt-get update && apt-get install -y runit gcc

# create conda environment
RUN conda create -n promptflow-serve python=3.11 pip -q -y && \
    conda run -n promptflow-serve \
    pip install -r /flow/requirements.txt && \
    conda run -n promptflow-serve pip install promptflow && \
    conda run -n promptflow-serve pip install keyrings.alt && \
    conda run -n promptflow-serve pip install gunicorn==23.0.0 && \
    conda run -n promptflow-serve pip install uvicorn==0.34.0 && \
    conda run -n promptflow-serve pip cache purge && \
    conda clean -a -y

COPY ./src /flow

EXPOSE 8080

# reset runsvdir
RUN rm -rf /var/runit
COPY ./runit /var/runit
# grant permission
RUN chmod -R +x /var/runit

COPY ./start.sh /
CMD ["bash", "./start.sh"]
