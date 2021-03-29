# Create Docker container that can run Gannet analyses.

# Start with the Matlab r2015b runtime container
FROM sergeicu/matlab-mcr:v96 

MAINTAINER Serge Vasylechko <serge.vasylechko@childrens.harvard.edu>

# Install dependencies
RUN apt-get update && apt-get install -y jq

# ADD the Matlab Stand-Alone (MSA) into the container.
ADD https://github.com/sergeicu/dce_recon_docker/raw/main/dce_recon /bin
ADD https://raw.githubusercontent.com/sergeicu/dce_recon_docker/main/run_dce_recon.sh /bin/run_dce_recon

# Ensure that the executable files are executable
RUN chmod +x /bin/*

# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
RUN mkdir -p ${FLYWHEEL}

# Copy and configure run script and metadata code
COPY run ${FLYWHEEL}/run
RUN chmod +x ${FLYWHEEL}/run
COPY manifest.json ${FLYWHEEL}/manifest.json

# Configure entrypoint
ENTRYPOINT ["/flywheel/v0/run"]
