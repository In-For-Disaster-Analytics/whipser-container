FROM mambaorg/micromamba:2.1.1-cuda12.3.2-ubuntu22.04
USER root
RUN apt-get update && apt-get install -y \
    curl \
    ffmpeg \
    file \
    && rm -rf /var/lib/apt/lists/*
USER mambauser
COPY --chown=$MAMBA_USER:$MAMBA_USER .binder/environment.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes
COPY --chmod=755 run.sh /tapis/run.sh
ENV PATH="/opt/conda/bin:${PATH}"
ENV PATH "/code:$PATH"
ENTRYPOINT [ "/tapis/run.sh" ]